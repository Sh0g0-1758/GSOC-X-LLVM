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
    fetch('oracle_results/' + jsonFileName)
        .then(response => response.json())
        .then(data => {
            jsonData = data;
            
            const knobValues = jsonData.knob_values;
            let stats = jsonData.graph_stats;
            const graphStats = jsonData.graph_stats_dict;
            
            // Calculate and display correlation coefficients
            const correlations = stats.map(stat => {
                return {
                    stat,
                    correlation: calculateCorrelation(knobValues, graphStats[stat])
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

            stats = stats.filter(stat => stat !== "compile-time (instructions)" && stat !== "bitcode-size (bytes)");

            // Flatten all the values from graphStats into a single array
            let allValues = stats.flatMap(stat => graphStats[stat]);

            // Find min and max values from the flattened array
            let minVal = Math.min(...allValues);
            let maxVal = Math.max(...allValues);

            const seriesData = stats.map(stat => {
                return {
                    name: stat,
                    type: 'line',
                    data: graphStats[stat],
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
            
            // Flatten all the values from graphStats into a single array
            allValues = selectedStats.flatMap(stat => graphStats[stat]);

            // Find min and max values from the flattened array
            minVal = Math.min(...allValues);
            maxVal = Math.max(...allValues);


            const newSeriesData = selectedStats.map(stat => {
                return {
                    name: stat,
                    type: 'line',
                    data: graphStats[stat],
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

            const headerRow = document.getElementById('header-row');
            const subHeaderRow = document.getElementById('sub-header-row');
            const tableBody = document.getElementById('table-body');

            // Create header rows
            knobValues.forEach(knob => {
                const th = document.createElement('th');
                th.colSpan = 6; // Each knob value has 6 sub-columns
                th.textContent = `Knob Value: ${knob}`;
                headerRow.appendChild(th);

                const subHeaders = ["No. of files which shows an increment", "No. of files which show a decrement", "No. of files which show no change", "Average % change over all the files", "Average % increase for files which showed an increment", "Average % decrease for files which showed a decrement"];
                subHeaders.forEach(subHeader => {
                    const thSub = document.createElement('th');
                    thSub.textContent = subHeader;
                    subHeaderRow.appendChild(thSub);
                });
            });
            
            stat_files_info = jsonData.stats_per_file
            let table_stats = jsonData.table_stats

            table_stats.forEach(stat => {
                const tr = document.createElement('tr');
                const statCell = document.createElement('td');
                statCell.classList.add('sticky-first-column');
                statCell.textContent = stat;
                tr.appendChild(statCell);

                knobValues.forEach((knob, i) => {
                    const statData = stat_files_info[i][stat]; // Get the data for the specific stat and knob value
                    statData.forEach(value => {
                        const td = document.createElement('td');
                        td.textContent = value;
                        tr.appendChild(td);
                    });
                });

                tableBody.appendChild(tr);
            });
            
            function createHistogram(containerId, data, title) {
                const chartDom = document.getElementById(containerId);
                const myChart = echarts.init(chartDom);
            
                const option = {
                    title: {
                        text: title,
                        left: 'center',
                        textStyle: {
                            fontSize: 16,
                            fontWeight: 'bold',
                            color: '#333'
                        }
                    },
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: {
                            type: 'shadow'
                        }
                    },
                    xAxis: {
                        type: 'category',
                        data: knobValues,
                        name: "Knob Value",
                        nameLocation: 'middle',
                        nameGap: 20,
                        nameTextStyle: {
                            fontSize: 12,
                            fontWeight: 'bold',
                            align: 'center'
                        },
                        axisLabel: {
                            rotate: 45,
                            interval: 0,
                            fontSize: 12,
                            color: '#555'
                        },
                        axisLine: {
                            lineStyle: {
                                color: '#aaa'
                            }
                        }
                    },
                    yAxis: {
                        type: 'value',
                        name: "Percentage Change",
                        nameLocation: 'middle',
                        nameRotate: 90,
                        nameGap: 50,
                        nameTextStyle: {
                            fontSize: 12,
                            fontWeight: 'bold',
                            align: 'center'
                        },
                        axisLabel: {
                            fontSize: 12,
                            color: '#555'
                        },
                        axisLine: {
                            lineStyle: {
                                color: '#aaa'
                            }
                        },
                        splitLine: {
                            lineStyle: {
                                type: 'dashed',
                                color: '#ddd'
                            }
                        }
                    },
                    grid: {
                        left: '5%',
                        right: '5%',
                        bottom: '20%',
                        containLabel: true
                    },
                    series: [
                        {
                            name: 'Cumulative % improvement (reduction)',
                            data: data.map(item => 0 - item[1]),
                            type: 'bar',
                            barWidth: '35%',
                            itemStyle: {
                                color: 'green'
                            }
                        },
                        {
                            name: 'Number of files which favor the knob value',
                            data: data.map(item => item[0]),
                            type: 'bar',
                            barWidth: '35%',
                            itemStyle: {
                                color: 'blue'
                            }
                        }
                    ]
                };
            
                myChart.setOption(option);
            }
            
        
            // Render histograms
            const compileTimeData = jsonData.compile_time_knobs_file;
            const bitcodeSizeData = jsonData.bitcode_size_knobs_file;
        
            createHistogram('histogram1', compileTimeData, 'Improvement (reduction) in Compile Time by applying Oracle-recommended knob values on a per file basis');
            createHistogram('histogram2', bitcodeSizeData, 'Improvement (reduction) in Bitcode Size by applying Oracle-recommended knob values on a per file basis');
            
            window.addEventListener('resize', function () {
                myChart.resize();
                newChart.resize();
                echarts.init(document.getElementById('histogram1')).resize();
                echarts.init(document.getElementById('histogram2')).resize();
            });

            // Add summary for oracle values

            // Add data to the summary table
            const summaryTableBody = document.getElementById('summaryTableBody');

            // Values from JSON
            const compileTimeSaving = 0 - jsonData.compile_time_saving_file;
            const bitcodeSizeSaving = 0 - jsonData.bitcode_size_saving_file;

            // Create rows for the summary table
            const compileTimeRow = document.createElement('tr');
            const compileTimeMetricCell = document.createElement('td');
            const compileTimeValueCell = document.createElement('td');
            compileTimeMetricCell.textContent = 'Compile Time';
            compileTimeValueCell.textContent = compileTimeSaving.toFixed(2) + " %";
            compileTimeRow.appendChild(compileTimeMetricCell);
            compileTimeRow.appendChild(compileTimeValueCell);

            const bitcodeSizeRow = document.createElement('tr');
            const bitcodeSizeMetricCell = document.createElement('td');
            const bitcodeSizeValueCell = document.createElement('td');
            bitcodeSizeMetricCell.textContent = 'Bitcode Size';
            bitcodeSizeValueCell.textContent = bitcodeSizeSaving.toFixed(2) + " %";
            bitcodeSizeRow.appendChild(bitcodeSizeMetricCell);
            bitcodeSizeRow.appendChild(bitcodeSizeValueCell);

            // Append rows to the summary table
            summaryTableBody.appendChild(compileTimeRow);
            summaryTableBody.appendChild(bitcodeSizeRow);

        })
        .catch(error => console.error('Error loading JSON:', error));
});
