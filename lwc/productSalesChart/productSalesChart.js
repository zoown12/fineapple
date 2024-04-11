import { LightningElement, wire } from 'lwc';
import getProductSalesCount from '@salesforce/apex/ProductSalesCountController.getProductSalesCount';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/chart';

export default class ProductSalesChart extends LightningElement {
    chart;
    chartjsInitialized = false;

    @wire(getProductSalesCount)
    wiredProductSalesCount({ error, data }) {
        if (error) {
            // 에러 핸들링
            console.error('Error loading product sales data', error);
        } else if (data) {
            // 차트 초기화
            this.initializeChart(data);
        }
    }

    initializeChart(data) {
        // Chart.js 스크립트 로드 확인
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;

        loadScript(this, CHARTJS)
            .then(() => {
                // 차트 데이터 구성
                const chartLabels = data.map(row => row.Name);
                const chartValues = data.map(row => row.salesCount);

                // 캔버스 엘리먼트 찾기
                const ctx = this.template.querySelector('canvas').getContext('2d');

                // 차트 생성
                this.chart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: chartLabels,
                        datasets: [{
                            label: '판매한 제품개수',
                            data: chartValues,
                            backgroundColor: 'rgb(230, 156, 21)',
                        }]
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                }
                            }]
                        }
                    }
                });
            })
            .catch(error => {
                console.error('Error loading Chart.js', error);
            });
    }
}