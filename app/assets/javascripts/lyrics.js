var code = (function() {

    // Whenever an artist is selected, retrieve and store their wc_data in this global var
    // This allows quick data loading whenever user moves minLength slider
    var global_wc_data = null;
    var global_artist_name = null;

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

    // Re-renders Highcharts
    var attachSelectArtistHandler = function() {
        var parent = document.getElementById("artist-list");
        parent.addEventListener('click', selectArtist, false);
    };

    // Re-render Highcharts
    var attachSliderChangeHandler = function() {
        var slider = document.getElementById('min-word-length');
        slider.addEventListener('change', renderHighcharts, false); 
    }

    // Calls controller: artists#show
    var selectArtist = function(e) {
        if (e.target !== e.currentTarget) {    
            var artistId = e.target.name;
            var minLength = document.getElementById("min-word-length").value;
            var data = {
                id: artistId,
                min: minLength
            };
            var onload = function(xhr) {
                if (xhr.status === 200) {
                    var response = (JSON.parse(xhr.responseText));
                    global_wc_data = response.fav_words;
                    global_artist_name = response.artist.name;
                    renderHighcharts();
                } else {
                    console.log("Status code: " + xhr.statusText);
                }
            };
            makeAjaxRequest('GET', '/artists/' + artistId + '?min=' + minLength, data, onload);

        }
        e.stopPropagation();
    };

    // Input: All wc, sorted by freq
    // Output (Filter): First 8 words >= minLength
    var calcSlider = function(wc_data, minLength) {
        var result = [];
        for (var i = 0; i < wc_data.length; i++) {
            if (result.length >= 8) {
                return result;
            }
            if (wc_data[i].word.length >= minLength) {
                result.push(wc_data[i]);
            }
        }
        return result;
    };

    // Called whenever artist clicked / slider moved
    var renderHighcharts = function() {
        var minLength = document.getElementById('min-word-length').value;
        var filtered_wc_data = calcSlider(global_wc_data, minLength);

        var words = [], counts = [], wc_2d_arr = [];

        for (var i = 0; i < filtered_wc_data.length; i++) {
            words.push(filtered_wc_data[i].word);
            counts.push(filtered_wc_data[i].count);
            wc_2d_arr.push([filtered_wc_data[i].word, filtered_wc_data[i].count]);
        }
        getBarChart(words, counts, global_artist_name, minLength);
        getDonutChart(wc_2d_arr, global_artist_name, minLength);
    };

    // Highcharts Code
    var getBarChart = function(words, counts, artist_name, minLength) {
        window.chart = new Highcharts.Chart({
            chart: {
                renderTo: 'bar-chart',
                height: 400,
                type: 'bar'
            },
            title: {
                text: artist_name + '\'s favorite words'
            },
            subtitle: {
                text: 'minimum length: ' + minLength
            },
            plotOptions: {
                series: {
                    animation: false
                }
            },
            xAxis: {
                categories: words
            },
            yAxis: {
                title: {
                    text: 'Word Frequency'
                }
            },
            series: [{
                name: artist_name,
                data: counts
            }]
        });
    };

    var getDonutChart = function(wc_2d_arr, artist_name, minLength) {
        window.chart = new Highcharts.Chart({
            chart: {
                renderTo: 'donut-chart',
                height: 400,
                type: 'pie',
                options3d: {
                    enabled: true,
                    alpha: 45
                }
            },
            title: {
                text: artist_name + '\'s favorite words'
            },
            subtitle: {
                text: 'minimum length: ' + minLength
            },
            plotOptions: {
                pie: {
                    innerSize: 100,
                    depth: 45
                },
                series: {
                    animation: false
                }
            },
            series: [{
                name: 'Word Frequency',
                data: wc_2d_arr
            }]
        });
    };

    var start = function() {
        attachSelectArtistHandler();
        attachSliderChangeHandler();
    };

    return {
        start: start
    };
})();

document.addEventListener('DOMContentLoaded', function() {
    code.start();
});