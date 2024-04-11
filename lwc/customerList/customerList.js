import { LightningElement, api, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import storeCustomerList from '@salesforce/apex/getStoreCustomerList.storeCustomerList';
import storeCustomerListSearch from '@salesforce/apex/getStoreCustomerList.storeCustomerListSearch';
export default class OpptyList extends NavigationMixin(LightningElement) {
    @api storeName; //viewRecords에서 넘겨받은 사용자의 지점ID
    customers;  //모든 고객 정보 저장
    @api searchCustomers;   //검색한 고객 정보 저장
    @api noDataFoundMessage;    //검색 결과가 없을 경우를 저장
    searchKey = undefined;

    columns = [
        { label: '고객 이름', fieldName: 'Name', type: 'button',typeAttributes: { label: { fieldName: 'Name' },name: 'view_details', variant: 'base' } },
        { label: '전화 번호', fieldName: 'Phone__c', type: 'phone' },
        { label: '누적 구매 금액', fieldName: 'TotalAmount', type: 'currency' }
    ];

    //해당 지점의 모든 고객 데려오기
    @wire(storeCustomerList, { storeName: '$storeName' })
    wiredCustomers({ error, data }) {
        if (data) {
            this.searchCustomers = undefined;
            this.customers = data.map(customer => ({
                ...customer,
                recordId: customer.CustomerID__c
            }));
        } else if (error) {
            console.error('Error fetching customers:', error);
        }
    }

    //검색 처리
    handleInputChange(event) {
        this.searchKey = event.target.value;
        if (this.searchKey.length > 0) {
            this.performSearch();
        } else {
            this.searchCustomers = undefined;
            this.noDataFoundMessage = undefined;
            this.refreshCustomers();
        }
    }

    //검색 조건에 해당하는 고객 데려오기
    performSearch() {
        storeCustomerListSearch({ searchKey: this.searchKey, storeName: this.storeName })
            .then(result => {
                this.customers = undefined;
                this.searchCustomers = result.map(customer => ({
                    ...customer,
                    recordId: customer.CustomerID__c, 
                    Name: customer.Name,
                    Phone__c: customer.Phone__c,
                    TotalAmount: customer.TotalAmount
                }));
                if(result.length === 0){
                    this.noDataFoundMessage = "검색 결과가 없습니다.";
                    this.searchCustomers = undefined;
                } else {
                    this.noDataFoundMessage = undefined;
                }
            })
            .catch(error => {
                this.error = error;
                this.searchCustomers = undefined;
                this.noDataFoundMessage = "고객 정보 검색 중 오류가 발생했습니다.";
            });
    }

    //검색 후 기본 보기로 돌아가는 refresh
    refreshCustomers() {
        storeCustomerList({ storeName: this.storeName })
            .then(result => {
                this.searchCustomers = undefined;
                this.noDataFoundMessage = undefined;
                this.customers = result.map(customer => ({
                    ...customer,
                    recordId: customer.CustomerID__c,
                    Name: customer.Name,
                    Phone__c: customer.Phone__c,
                    TotalAmount: customer.TotalAmount
                }));
                //this.noDataFoundMessage = result.length === 0 ? "검색 결과가 없습니다." : undefined;
            })
            .catch(error => {
                this.error = error;
                this.customers = undefined;
                this.noDataFoundMessage = "고객 정보를 불러오는 중 오류가 발생했습니다.";
            });
    }


    //각 행 클릭시 해당 레코드로 이동
    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        if (action.name === 'view_details') {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',   
            attributes: {
                recordId: row.recordId,
                objectApiName: 'CustomerCu__c', 
                actionName: 'view'
            }
        });
    }
    }
}