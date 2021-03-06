AM = Artificial.Mirage
LOI = LandsOfIllusions
PAA = PixelArtAcademy

class PAA.PixelBoy.Apps.Drawing.Editor.Desktop.ColorFill extends AM.Component
  @register 'PixelArtAcademy.PixelBoy.Apps.Drawing.Editor.Desktop.ColorFill'
  
  onCreated: ->
    super arguments...
    
    @editor = @ancestorComponentOfType PAA.PixelBoy.Apps.Drawing.Editor.Desktop

  colorStyle: ->
    # Get the color from the palette.
    colorData = @editor.palette().currentColor()
    return unless colorData

    color = THREE.Color.fromObject colorData
    active = @editor.activeTool() instanceof LOI.Assets.Components.Tools.ColorFill

    backgroundColor: "##{color.getHexString()}"
    opacity: if active then 1 else 0.8
