---
date: 2020-05-15 21:30:00 +0900
title: Kansai Cinema / Mapbox
mapbox: true
jsinclude: mapjs/06_kansai-cinema-mapbox.js
---

* [Mapbox <=> Leaflet]({% post_url 2020-05-15-mapbox-leaflet %})
* [Kansai Cinema / Mapbox]({% post_url 2020-05-15-kansai-cinema-mapbox %})
* [Kansai Cinema / Leaflet]({% post_url 2020-05-12-kansai-cinema-leaflet %})


[Mapbox <=> Leaflet]({% post_url 2020-05-15-mapbox-leaflet %})
で書かせていただいた通り・・・

* Leaflet ではオーバレイのひとつだった GeoJSON ですが・・・
* Mapbox では `Source` として、背景地図と同等の扱いを受ける。  
  （背景地図はこの場合ベクトルタイル ）

きょうはこれを、GeoJSON を Mapbox に表示することを通して、
具体的にみていきたい。


# 実践

## ベースとなるコードを書く

* 一応、ここの例を書きますが（ソース表示すればわかりますが）、  
  本家さんのヘルプ丸写しなので皆様もそちらを丸写ししてください。

### ヘッダ部

```html
<meta
  name="viewport"
  content="initial-scale=1,maximum-scale=1,user-scalable=no">
<link
  rel="stylesheet" type="text/css"
  href="https://api.mapbox.com/mapbox-gl-js/v{{ site.data.versions.mapbox }}/mapbox-gl.css" />
<script
  src="https://api.mapbox.com/mapbox-gl-js/v{{ site.data.versions.mapbox }}/mapbox-gl.js"
  ></script>
```

### ボディ部

```html
<div id="map"></div>
<script>
  var map = new mapboxgl.Map({
    container: 'map',
    style: '/assets/map/jp1710-style.json',
    attributionControl: true,
    hash: true
  });
  map.addControl(new mapboxgl.NavigationControl());
</script>
```

### スタイルファイル

```
（省略）
```

* [jp1710](https://qiita.com/hfu/items/e7c0318bba67827d4327)
  からいただいたものです。
* 緯度経度とズームレベルの初期値だけ変えました。  
  （大阪中心にしました！）。


## GeoJSON 乗せる

### `Source` として GeoJSON を add する

```javascript
map.addSource( 'kansai-cinema', {
  type: 'geojson',
  data: '/assets/map/kansai-cinema.geojson'
});
```

### `Source` を`Layer` に 引いてきて add する

OpenStreetMap には

1. 「ノード」すなわち「点」として入れられている映画館
2. 「ウェイ」すなわち「建物の輪郭」が入れられている映画館

この２種類があり、GeoJSON に出力した時に

1. 「ノード」はジオメトリタイプ `Point` として出力
2. 「ウェイ」はジオメトリタイプ `LineString` として出力
3. 「ウェイ」で「囲まれた部分」はまた `MultiPolygon` としても出力

されていることがわかった。

従って今回は・・・

* `Point`（地点としての映画館）を「点／円盤 `circle`」として表示。
  * Leaflet でいう CircleMaker みないなものになります。  
    （ズームイン／アウトしても大きさが変わらない（ピクセル指定））。
* `MultiPolygon`（建物の本体）を「塗り `fill`」として表示
* `LineString`（建物の輪郭線）を「線 `line`」として表示

することとした。

なお、GeoJSON から `filter` 条件で抽出する場合、

* `Point` は `Point` のままで、
* `LineString` も `LineString` のままでよいが、
* `MultiPolygon` は `Polygon` として

条件指定しなければ取り出されないようだ。

京都千本日活が、「ノード」としても「ウェイ」としても
登録されていることがわかった。
ズームレベルを上げるにつれ、建物の大きさがマーカの
円盤のピクセルを超えて大きくなってくる様子を見ることができる。

下記リンクをクリックで冒頭の地図が千本日活付近へズームします。

* [京都千本日活へズーム](javascript:zoomInSenbon();)


### これらを `map.on('load',` でくるむ

マップのロード完了前に実行されてしまうとエラーとなるため。


# 結果

ページ冒頭の通り。


# Source:

```javascript
{% include_relative {{ page.jsinclude }} %}
```
