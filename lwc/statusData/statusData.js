import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/chart';
import getStoreData from '@salesforce/apex/GetStatusData.getStoreData';
import getStoreEmptyData from '@salesforce/apex/GetStatusData.getStoreEmptyData';
import Id from "@salesforce/user/Id";

export default class StoreChart extends LightningElement {
  userId = Id;
  @track combinedData = [];
  chartjsInitialized = false;

  connectedCallback() {
      // 비동기 Apex 호출을 위한 코드 수정
      Promise.all([
          getStoreData({ ownerId: this.userId }),
          getStoreEmptyData({ ownerId: this.userId })
      ])
        .then(results => {
            this.processData(results[0], 'purchase');
            this.processData(results[1], 'empty');
            this.initializeChart(this.combinedData);
        })
        .catch(error => {
            console.error('Error loading data:', error);
        });
    }

    processData(data, type) {
      data.forEach(item => {
          const key = `${item.year}-${item.month}`;
          let record = this.combinedData.find(record => record.key === key);
  
          if (!record) {
              record = {
                  key,
                  year: item.year,
                  month: item.month,
                  purchaseCount: 0,
                  notPurchaseCount: 0
              };
              this.combinedData.push(record);
          }
  
          if (type === 'purchase') {
              record.purchaseCount = item.statusCount;
          } else {
              record.notPurchaseCount = item.statusCount;
          }
      });
  
      // 데이터를 '년도'와 '월' 기준으로 정렬
      this.combinedData.sort((a, b) => {
          return a.year - b.year || a.month - b.month;
      });
  
      // 차트를 바로 초기화하도록 조건을 제거함
      this.initializeChart(this.combinedData);
  }

    initializeChart(data) {
        if (this.chartjsInitialized) {
            console.log('Chart already initialized.');
            return;
        }
        this.chartjsInitialized = true;

        loadScript(this, CHARTJS).then(() => {
            const canvas = this.template.querySelector('canvas');
            const ctx = canvas.getContext('2d');

            // 라벨과 데이터 매핑 로직은 기존대로 유지
            const labels = data.map(item => item.key);
            const purchaseCounts = data.map(item => item.purchaseCount);
            const notPurchaseCounts = data.map(item => item.notPurchaseCount);

            this.chart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels,
                    datasets: [
                        {
                            label: '구매 고객',
                            data: purchaseCounts,
                            borderColor: 'rgb(255, 99, 132)',
                            backgroundColor: 'rgba(255, 99, 132, 0.5)',
                        },
                        {
                            label: '미구매 고객',
                            data: notPurchaseCounts,
                            borderColor: 'rgb(54, 162, 235)',
                            backgroundColor: 'rgba(54, 162, 235, 0.5)',
                        }
                    ]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        title: {
                            display: true,
                            text: 'Monthly Store Chart'
                        }
                    }
                },
            });
        }).catch(error => {
            console.error('Failed to load Chart.js:', error);
        });
    }
}