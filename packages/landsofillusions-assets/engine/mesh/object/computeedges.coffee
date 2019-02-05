LOI = LandsOfIllusions

LOI.Assets.Engine.Mesh.Object.computeEdges = (clusters) ->
  edges = []
  return edges unless clusters.length

  console.log "Computing edges between clusters", clusters if LOI.Assets.Engine.Mesh.debug

  for clusterIndexA in [0...clusters.length - 1]
    for clusterIndexB in [clusterIndexA + 1...clusters.length]
      # Detect an edge between the two clusters.
      clusterA = clusters[clusterIndexA]
      clusterB = clusters[clusterIndexB]
      
      edge = new LOI.Assets.Engine.Mesh.Object.Edge clusterA, clusterB
        
      for pixel in clusterA.pixels
        coordinates = clusterA.getAbsolutePixelCoordinates pixel

        # Detect edges with neighboring pixels on all 4 sides. Edge vertices are directed
        # so that cluster A is on the right of the segment, cluster B on the left.
        if pixel.clusterEdges.left and clusterB.findPixelAtAbsoluteCoordinate(coordinates.x - 1, coordinates.y)?.clusterEdges.right
          edge.addSegment coordinates, 0, 1, 0, 0

        if pixel.clusterEdges.right and clusterB.findPixelAtAbsoluteCoordinate(coordinates.x + 1, coordinates.y)?.clusterEdges.left
          edge.addSegment coordinates, 1, 0, 1, 1

        if pixel.clusterEdges.up and clusterB.findPixelAtAbsoluteCoordinate(coordinates.x, coordinates.y - 1)?.clusterEdges.down
          edge.addSegment coordinates, 0, 0, 1, 0

        if pixel.clusterEdges.down and clusterB.findPixelAtAbsoluteCoordinate(coordinates.x, coordinates.y + 1)?.clusterEdges.up
          edge.addSegment coordinates, 1, 1, 0, 1

        # Detect edges with overlapping pixels.
        if pixel.clusterEdges.left and clusterB.findPixelAtAbsoluteCoordinate(coordinates.x , coordinates.y)?.clusterEdges.left
          edge.addSegment coordinates, 0, 1, 0, 0

        if pixel.clusterEdges.right and clusterB.findPixelAtAbsoluteCoordinate(coordinates.x, coordinates.y)?.clusterEdges.right
          edge.addSegment coordinates, 1, 0, 1, 1

        if pixel.clusterEdges.up and clusterB.findPixelAtAbsoluteCoordinate(coordinates.x, coordinates.y)?.clusterEdges.up
          edge.addSegment coordinates, 0, 0, 1, 0

        if pixel.clusterEdges.down and clusterB.findPixelAtAbsoluteCoordinate(coordinates.x, coordinates.y)?.clusterEdges.down
          edge.addSegment coordinates, 1, 1, 0, 1

      # See if we found any neighbors.
      continue unless edge.segments.length

      edge.process()

      console.log "Computed edge between clusters #{clusterIndexA} and #{clusterIndexB}", edge if LOI.Assets.Engine.Mesh.debug

      edges.push edge
      clusterA.edges.push edge
      clusterB.edges.push edge

  console.log "Created edges", edges if LOI.Assets.Engine.Mesh.debug

  edges
