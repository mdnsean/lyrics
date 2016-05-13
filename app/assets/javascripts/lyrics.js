var code = (function() {

    var makeAjaxRequest = function(method, url, data, onload) {
        var xhr = new XMLHttpRequest();
        xhr.onload = function() {
            onload(xhr);
        };
        xhr.open(method, url, true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.setRequestHeader('Data-Type', 'json');
        xhr.send(JSON.stringify(data));
    };

    var attachSelectArtistHandler = function() {
        var parent = document.getElementById("artist-list");
        parent.addEventListener('click', selectArtist, false);
    };

    var selectArtist = function(e) {
        if (e.target !== e.currentTarget) {    
            var artistId = e.target.name;
            var data = {
                id: artistId
            };
            var onload = function(xhr) {
                if (xhr.status === 200) {
                    var response = (JSON.parse(xhr.responseText));
                    displayWordcounts(response.wc_data);
                } else {
                    console.log("Status code: " + xhr.statusText);
                }
            };
            makeAjaxRequest('GET', '/artists/' + artistId, data, onload);

        }
        e.stopPropagation();
    };

    var displayWordcounts = function(data) {
        var table = document.getElementById("wc-table");
        table.innerHTML = "";
        for (var i = 0; i < data.length; i++) {
            table.innerHTML += "<tr><td>" + data[i].word
                            + "</td><td>" + data[i].count
                            + "</td></tr>";
        }
    };

  /* D3 Cloud */

  // var width = document.body.clientWidth;
  // var height = window.innerHeight - document.querySelector('header').clientHeight - 40;
  var width = window.innerWidth;
  var height = window.innerHeight;

  var typeFace = 'Impact';
  var minFontSize = 24;
  var colors = d3.scale.category20b();

  var svg = d3.select('#cloud').append('svg')
      .attr('width', width)
      .attr('height', height)
      .append('g')
      .attr('transform', 'translate('+width/2+', '+height/2+')');

  function update(wcData) {
    d3.layout.cloud()
      .size([width, height])
      .words(wcData)
      .rotate(function() { return ~~(Math.random()*2) * 90;}) // 0 or 90deg
      .font(typeFace)
      .fontSize(function(d) { return d.size * minFontSize; }) // fontSize(+d.value)
      .on('end', draw)
      .start();
  }

  function draw(words) {
    var text = svg.selectAll('text').data(words);

    text.enter().append('text')
      .style('font-size', function(d) { return d.size + 'px'; })
      .style('font-family', function(d) { return d.font; })
      .style('fill', function(d, i) { return colors(i); })
      .attr('text-anchor', 'middle')
      .attr('transform', function(d) {
        return 'translate(' + [d.x, d.y] + ')rotate(' + d.rotate + ')';
      })
      .text(function(d) { return d.text; }); // return d.key (key,value)
  }

    var wcData = [{'text': 'big', 'size': 3}, {'text': 'small', 'size': 1}];

    var start = function() {
        attachSelectArtistHandler();
        update(wcData);
    };

    return {
        start: start
    };
})();

document.addEventListener('DOMContentLoaded', function() {
    code.start();
});