require ['when'], (When) ->
  class WorkerPool
    pool: []
    @tasks: []

    constructor: (@workerScript, size = 1) ->
      @reset size

    reset: (size) ->
      if @pool.length > 0
        @pool.forEach (worker, index) ->
          @worker.obj.terminate()
          delete @pool[index]

      @grow for i in [0..size]

    grow: ->
      worker =
        obj: new Worker @workerScript,
        free: yes

      @pool.push worker
      worker

    getWorker: (cb) ->
      freeWorkers = worker @pool where worker.free is yes
      if freeWorkers.length is 0
        @on 'worker:released', cb
      else
        cb.call freeWorkers.pop()

    shrink: ->
      @pool.pop()

    addTask: (task) ->
      task.id = @tasks.length if not task.id?
      @tasks.push task
      @

    runTask: (id, cb) ->
      deferred = When.defer()
      task = task in @tasks where task.id is id
      @getWorker (worker) ->
        worker.free = no
        worker.obj.postMessage task
        worker.obj.onmessage = (e) ->
          deferred.resolve()

      deferred.promise

    run: ->
      deferred = When.defer()
      @runTask(task.id) for task in @tasks
      deferred.promise