(function() {

  /* D3  */

  var width = document.body.clientWidth;
  var height = window.innerHeight - document.querySelector('header').clientHeight - 40;

  var typeFace = 'Impact';
  var minFontSize = 24;
  var colors = d3.scale.category20b();

  var svg = d3.select('#cloud').append('svg')
      .attr('width', width)
      .attr('height', height)
      .append('g')
      .attr('transform', 'translate('+width/2+', '+height/2+')');

  function update(wcHash) {
    d3.layout.cloud()
      .size([width, height])
      .words(wcHash)
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

  update(myHash);
  
})();