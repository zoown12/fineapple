//vocChart.js
import { LightningElement,wire } from 'lwc';
import getVoCCountOfMonthly from '@salesforce/apex/VoCCountOfMonthly.getVoCCountOfMonthly';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/chart';

export default class VocChart extends LightningElement {
    chart;
    chartjsInitialized = false;

    @wire(getVoCCountOfMonthly)
    wiredVocCnt({ error, data }) {
        if (error) {
            // 오류 처리
            console.error('Error:', error);
        } else if (data) {
            // 데이터가 성공적으로 로드되면 차트 초기화
            this.initializeChart(data);
        }
    }

    initializeChart(data) {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;

        loadScript(this, CHARTJS)
            .then(() => {
                // 차트 데이터 구성
                const chartLabels = data.map(result => result.year+'년'+result.month+'월');
                const chartValues = data.map(result => result.vocCount);

                const canvas = this.template.querySelector('canvas');
                const ctx = canvas.getContext('2d');

                this.chart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: chartLabels,
                        datasets: [{
                            label: '월별 VoC 건수',
                            backgroundColor: 'rgb(230, 156, 21)',
                            data: chartValues,
                        }]
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }
                            }]
                        },
                        responsive: true
                    }
                });
            })
            .catch(error => {
                console.error('Chart.js failed to load', error);
            });
    }
}