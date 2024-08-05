function calculateCorrelation(x, y) {
    let n = x.length;
    let sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;
    
    for (let i = 0; i < n; i++) {
        sumX += x[i];
        sumY += y[i];
        sumXY += x[i] * y[i];
        sumX2 += x[i] * x[i];
        sumY2 += y[i] * y[i];
    }
    
    let numerator = (n * sumXY) - (sumX * sumY);
    let denominator = Math.sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));
    
    return numerator / denominator;
}

function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
}

document.addEventListener("DOMContentLoaded", function () {
    const jsonFileName = getQueryParam('file');
    fetch('content/' + jsonFileName)
        .then(response => response.json())
        .then(data => {
            jsonData = data;
            
            const knobValues = jsonData.knob_values;
            let stats = jsonData.stats;
            const statsVal = jsonData.stats_val;

            stats = stats.filter(stat => stat !== "compile-time (instructions)" && stat !== "bitcode-size (bytes)");

            // Flatten all the values from statsVal into a single array
            let allValues = stats.flatMap(stat => statsVal[stat]);

            // Find min and max values from the flattened array
            let minVal = Math.min(...allValues);
            let maxVal = Math.max(...allValues);

            const seriesData = stats.map(stat => {
                return {
                    name: stat,
                    type: 'line',
                    data: statsVal[stat],
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
                    formatter: function (params) {
                        let data_string = "";
                        if(params.value > 0) {
                            data_string = `<b style="color:green;"> Increase: ${params.value} % </b> <br/>`;
                        } else if (params.value < 0){
                            data_string = `<b style="color:red;"> Decrease: ${params.value} % </b> <br/>`;
                        } else {
                            data_string = `<b style="color:blue;"> No Change: ${params.value} % </b> <br/>`;
                        }
                        return `
                            <b style="color:black;"> Stat Name: ${params.seriesName}</b><br/>
                            ${data_string}
                            <b> Knob Value: ${params.name}</b><br/>
                        `;
                    }
                },
                legend: {
                    data: stats,
                    type: 'scroll',
                    orient: 'horizontal', 
                    bottom: '5%',
                    left: 'center',
                    width: '80%',
                    textStyle: {
                        fontSize: 10
                    },
                },

                toolbox: {
                    feature: {
                        saveAsImage: {}
                    }
                },
                grid: {
                    left: '2%',
                    right: '2%',
                    bottom: '9%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: knobValues,
                    name: "KNOB VALUE",
                    nameLocation: 'middle',
                    nameGap: 20, 
                    nameTextStyle: {
                        fontSize: 12,
                        fontWeight: 'bold', 
                        align: 'center'
                    },
                    axisLabel: {
                        rotate: 45,
                        interval: 0
                    }
                },
                yAxis: {
                    type: 'value',
                    name: "Percentage Increase/Decrease from Original Stats Value",
                    nameLocation: 'middle',
                    nameRotate: 90, 
                    nameGap: 50, 
                    nameTextStyle: {
                        fontSize: 12, 
                        fontWeight: 'bold', 
                        align: 'center'
                    },
                    min: minVal,
                    max: maxVal,
                },
                series: seriesData,
                dataZoom: [
                    {
                        type: 'inside',
                        start: 0,
                        end: 100
                    },
                    {
                        type: 'slider',
                        start: 0,
                        end: 100,
                        bottom: '2%',
                        height: 20
                    }
                ]
            };
            myChart.setOption(option);

            const selectedStats = ["compile-time (instructions)", "bitcode-size (bytes)"];
            
            // Flatten all the values from statsVal into a single array
            allValues = selectedStats.flatMap(stat => statsVal[stat]);

            // Find min and max values from the flattened array
            minVal = Math.min(...allValues);
            maxVal = Math.max(...allValues);


            const newSeriesData = selectedStats.map(stat => {
                return {
                    name: stat,
                    type: 'line',
                    data: statsVal[stat],
                    smooth: true,
                    lineStyle: {
                        width: 2
                    },
                    emphasis: {
                        focus: 'series'
                    }
                };
            });

            const newChartDom = document.getElementById('secondary');
            const newChart = echarts.init(newChartDom);

            const newOption = {
                tooltip: {
                    trigger: "item",
                    formatter: function (params) {
                        let data_string = "";
                        if(params.value > 0) {
                            data_string = `<b style="color:red;"> Increase: ${params.value} % </b> <br/>`;
                        } else if (params.value < 0){
                            data_string = `<b style="color:green;"> Decrease: ${params.value} % </b> <br/>`;
                        } else {
                            data_string = `<b style="color:blue;"> No Change: ${params.value} % </b> <br/>`;
                        }
                        return `
                            <b style="color:black;"> Stat Name: ${params.seriesName}</b><br/>
                            ${data_string}
                            <b> Knob Value: ${params.name}</b><br/>
                        `;
                    }
                },
                legend: {
                    data: selectedStats,
                    type: 'scroll',
                    orient: 'horizontal', 
                    bottom: '5%',
                    left: 'center',
                    width: '80%',
                    textStyle: {
                        fontSize: 10
                    },
                },

                toolbox: {
                    feature: {
                        saveAsImage: {}
                    }
                },
                grid: {
                    left: '2%',
                    right: '2%',
                    bottom: '9%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: knobValues,
                    name: "KNOB VALUE",
                    nameLocation: 'middle',
                    nameGap: 20, 
                    nameTextStyle: {
                        fontSize: 12,
                        fontWeight: 'bold', 
                        align: 'center'
                    },
                    axisLabel: {
                        rotate: 45,
                        interval: 0
                    }
                },
                yAxis: {
                    type: 'value',
                    name: "Percentage Increase/Decrease from Original Stats Value",
                    nameLocation: 'middle',
                    nameRotate: 90, 
                    nameGap: 50, 
                    nameTextStyle: {
                        fontSize: 12, 
                        fontWeight: 'bold', 
                        align: 'center'
                    },
                    min: minVal,
                    max: maxVal,
                },
                series: newSeriesData,
                dataZoom: [
                    {
                        type: 'inside',
                        start: 0,
                        end: 100
                    },
                    {
                        type: 'slider',
                        start: 0,
                        end: 100,
                        bottom: '2%',
                        height: 20
                    }
                ]
            };
            newChart.setOption(newOption);

            window.addEventListener('resize', function () {
                myChart.resize();
                newChart.resize();
            });

            // Calculate and display correlation coefficients
            const correlations = stats.map(stat => {
                return {
                    stat,
                    correlation: calculateCorrelation(knobValues, statsVal[stat])
                };
            });

            correlations.sort((a, b) => Math.abs(b.correlation) - Math.abs(a.correlation));

            const correlationTableBody = document.getElementById('correlationTableBody');
            correlations.forEach(({ stat, correlation }) => {
                const row = document.createElement('tr');
                const statCell = document.createElement('td');
                const correlationCell = document.createElement('td');

                // Apply styles based on correlation strength
                if (Math.abs(correlation) >= 0.5) {
                    row.style.backgroundColor = '#d0f0c0'; // Strong correlation
                } else if (Math.abs(correlation) >= 0.3) {
                    row.style.backgroundColor = '#fffacd'; // Moderate correlation
                } else {
                    row.style.backgroundColor = '#e0ffff '; // Weak correlation
                }

                statCell.textContent = stat;
                correlationCell.textContent = correlation.toFixed(2);
                row.appendChild(statCell);
                row.appendChild(correlationCell);
                correlationTableBody.appendChild(row);
            });

        })
        .catch(error => console.error('Error loading JSON:', error));
});
