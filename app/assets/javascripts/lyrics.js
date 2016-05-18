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
                    displayFavWords(response.fav_words, response.artist);
                } else {
                    console.log("Status code: " + xhr.statusText);
                }
            };
            makeAjaxRequest('GET', '/artists/' + artistId, data, onload);

        }
        e.stopPropagation();
    };

    // artists#show
    var displayFavWords = function(wc_data, artist) {
        // var table = document.getElementById("wc-table");
        // table.innerHTML = "";
        // table.innerHTML += artist.name

        var words = [];
        var counts = [];
        for (var i = 0; i < wc_data.length; i++) {
            // table.innerHTML += "<tr><td>" + wc_data[i].word
            //                 + "</td><td>" + wc_data[i].count
            //                 + "</td></tr>";
            words.push(wc_data[i].word);
            counts.push(wc_data[i].count);
        }
        getFavWordsChart(words, counts, artist.name);
    };

    // Highcharts
    var longestWordCharts = function(words, counts, artist_name) {
        window.chart = new Highcharts.Chart({
            chart: {
                renderTo: longest-words,
                height: 400,
                type: 'bar'
            },
            title: {
                text: 'Everyone\'s Favorite Words'
            },
            xAxis: {
                categories: words
            },
            yAxis: {
                title: {
                    text: 'Word Frequency'
                }
            },
            series: [
            {
                name: artist_name,
                data: counts
            }
            ]
        });
    };


    var getFavWordsChart = function(words, counts, artist_name) {
        window.chart = new Highcharts.Chart({
            chart: {
                renderTo: 'fav-words',
                height: 400,
                type: 'bar'
            },
            title: {
                text: artist_name + '\'s favorite words'
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