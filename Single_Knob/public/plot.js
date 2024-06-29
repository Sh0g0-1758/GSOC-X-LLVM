document.addEventListener("DOMContentLoaded", function () {
    fetch('plot.json')
        .then(response => response.json())
        .then(data => {
            jsonData = data;
            
            const knobValues = jsonData.knob_values;
            const stats = jsonData.stats;
            const statsVal = jsonData.stats_val;

            statsVal['COMPILE TIME'] = {
                "normalized_values": jsonData.time_arr,
                "min": jsonData.time_min,
                "max": jsonData.time_max
            };
            stats.push('COMPILE TIME');

            const seriesData = stats.map(stat => {
                return {
                    name: stat,
                    type: 'line',
                    data: statsVal[stat].normalized_values,
                    smooth: true,
                    lineStyle: {
                        width: 2
                    },
                    emphasis: {
                        focus: 'series'
                    }
                };
            });

            const chartDom = document.getElementById('main');
            const myChart = echarts.init(chartDom);

            const option = {
                title: {
                    text: `| KNOB NAME : ${jsonData.knob_name} | ORIGINAL VALUE : ${jsonData.original_val} |`,
                    left: 'center'
                },
                tooltip: {
                    trigger: "item",
                    formatter: function(params) {
                        return `<strong>${params.seriesName}</strong><br>` +
                               `Knob Value: ${params.name}<br>` +
                               `Value: ${((statsVal[params.seriesName].max - statsVal[params.seriesName].min) * params.value) + statsVal[params.seriesName].min}<br>`;
                    }
                },
                legend: {
                    data: stats,
                    type: 'scroll',
                    top: 'bottom',
                    width: '80%',
                    textStyle: {
                        fontSize: 10
                    }
                },
                toolbox: {
                    feature: {
                        saveAsImage: {}
                    }
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: knobValues,
                    axisLabel: {
                        rotate: 45,
                        interval: 0
                    }
                },
                yAxis: {
                    type: 'value',
                    min: 0,
                    max: 1,
                },
                series: seriesData,
            };
            myChart.setOption(option);

            window.addEventListener('resize', function () {
                myChart.resize();
            });
        })
        .catch(error => console.error('Error loading JSON:', error));
});
