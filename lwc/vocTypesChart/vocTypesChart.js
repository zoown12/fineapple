import { LightningElement, wire } from 'lwc';
import getVocTypeCounts from '@salesforce/apex/VocTypeCountController.getVocTypeCounts';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/chart';

export default class VocTypesChart extends LightningElement {
    chart;
    chartjsInitialized = false;

    @wire(getVocTypeCounts)
    wiredVocTypes({ error, data }) {
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
                const chartLabels = data.map(result => result.VocType__c);
                const chartValues = data.map(result => result.vocCount);

                const canvas = this.template.querySelector('canvas');
                const ctx = canvas.getContext('2d');

                this.chart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: chartLabels,
                        datasets: [{
                            label: '유형별 상담횟수',
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