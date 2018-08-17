PAA = PixelArtAcademy
Entry = PAA.PixelBoy.Apps.Journal.JournalView.Entry
IL = Illustrapedia

class Entry.Object.Task extends Entry.Object
  @id: -> 'PixelArtAcademy.PixelBoy.Apps.Journal.JournalView.Entry.Object.Task'
  @version: -> '0.1.0'

  @register @id()
  template: -> @constructor.id()

  @registerBlot
    name: 'task'
    tag: 'p'
    class: 'pixelartacademy-pixelboy-apps-journal-journalview-entry-object-task'

  onCreated: ->
    super

    value = @value()
    taskClass = PAA.Learning.Task.getClassForId value.id
    goalClass = taskClass.goal()

    @goal = new goalClass
    @task = _.find @goal.tasks(), (task) => task instanceof taskClass

    @taskComponent = new @constructor[taskClass.type] @

    @_taskEntrySubscription = PAA.Learning.Task.Entry.forCharacterTaskIds.subscribe LOI.characterId(), [@task.id()]

  onDestroyed: ->
    super

    @goal.destroy()

  completedClass: ->
    'completed' if @task.completed()

  ready: ->
    @_taskEntrySubscription.ready()

  readyClass: ->
    # We are ready when we're sure we got the entry if it exists.
    'ready' if @ready()
