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

    // calls controller: artists#show
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
                    var filtered_wc_data = calcSlider(response.fav_words, minLength);
                    // cacheWc()?
                    displayFavWords(filtered_wc_data, response.artist, minLength);
                } else {
                    console.log("Status code: " + xhr.statusText);
                }
            };
            makeAjaxRequest('GET', '/artists/' + artistId + '?min=' + minLength, data, onload);

        }
        e.stopPropagation();
    };

    // Input: all wc, sorted by freq
    // Output (Filter): first 8 words >= minLength
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

    // Render Highcharts for selected artist
    var displayFavWords = function(wc_data, artist, minLength) {
        // var table = document.getElementById("wc-table");
        // table.innerHTML = "";
        // table.innerHTML += artist.name

        var words = [], counts = [], wc_2d_arr = [];

        for (var i = 0; i < wc_data.length; i++) {
            // table.innerHTML += "<tr><td>" + wc_data[i].word
            //                 + "</td><td>" + wc_data[i].count
            //                 + "</td></tr>";
            words.push(wc_data[i].word);
            counts.push(wc_data[i].count);
            wc_2d_arr.push([wc_data[i].word, wc_data[i].count]);
        }
        getBarChart(words, counts, artist.name, minLength);
        getDonutChart(wc_2d_arr, artist.name, minLength);
    };

    // Highcharts
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
    };

    return {
        start: start
    };
})();

document.addEventListener('DOMContentLoaded', function() {
    code.start();
});