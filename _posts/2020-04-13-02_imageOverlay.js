---
layout: leaflet
---
      var map = L.map('map').setView([0, 0], 0);

      L.tileLayer('/tiles/osmlogo/{z}/{y}/{x}.png', {
        attribution: 'attr',
        maxZoom: 4,
      }).addTo(map);

      // image overlay
      var imageUrl = "/assets/for-leaflet-lesson/Cat_silhouette.svg"; // "Cat_silhouette.png";
      var imageBounds = [[10, 30], [70, 130]];
      L.imageOverlay( imageUrl, imageBounds ).addTo(map);
