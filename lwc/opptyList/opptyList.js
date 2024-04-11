import { LightningElement,wire,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import storeAllList from '@salesforce/apex/getStoreSalesList.storeAllList';
import storeOpptyList from '@salesforce/apex/getStoreSalesList.storeOpptyList';
import storeLeadList from '@salesforce/apex/getStoreSalesList.storeLeadList';

const columns = [
    { label: 'Oppty ID', fieldName: 'Name', type: 'button',typeAttributes: { label: { fieldName: 'Name' },name: 'view_details', variant: 'base' } },
    { label: '판매 상태', fieldName: 'OpptyStageGroup__c', type: 'text' },
    { label: '상담 일자', fieldName: 'OpptyConsultDate__c', type: 'date' },
];

export default class OpptyList extends NavigationMixin(LightningElement) { 
    columns = columns;
    @api storeName;
    sales;
    oppties;
    leads;


    value = 'ALL';
    get options() {
        return [
            { label: 'ALL', value: 'ALL' },
            { label: '고객 정보 O', value: 'customerInfo' },
            { label: '고객 정보 x', value: 'noneInfo' },
        ];
    }

    //지점의 모든 판매 가져오기
    @wire(storeAllList,{storeName:'$storeName'})
    wiredSalesList({error,data}){
        if(data){
            this.sales = data;
            this.error = undefined;
        } else if(error){
            this.sales = undefined;
            this.error = error;
        }
    }

    //콤보박스 각 옵션 클릭시 처리
    handleChange(event) {
        this.value = event.detail.value;
        if(this.value === 'ALL'){
            storeAllList({ storeName: this.storeName }).then(result => {
                this.sales = result.map(oppty => ({
                    ...oppty,
                    recordId: oppty.Id,
                    OpptyStageGroup__c: oppty.OpptyStageGroup__c,
                    OpptyConsultDate__c: oppty.OpptyConsultDate__c
                }));
                this.oppties = undefined;
                this.leads = undefined;
            }).catch(error => {
                this.error = error;
            });
    } else if(this.value ==='customerInfo'){
        storeOpptyList({ storeName: this.storeName }).then(result => {
            this.oppties = result.map(oppty => ({
                ...oppty,
                recordId: oppty.Id,
                OpptyStageGroup__c: oppty.OpptyStageGroup__c,
                OpptyConsultDate__c: oppty.OpptyConsultDate__c
            }));
            this.sales = undefined;
            this.leads = undefined;
        }).catch(error => {
            this.error = error;
        });
    }
    else if(this.value ==='noneInfo'){
        storeLeadList({ storeName: this.storeName }).then(result => {
            this.leads = result.map(oppty => ({
                ...oppty,
                recordId: oppty.Id,
                OpptyStageGroup__c: oppty.OpptyStageGroup__c,
                OpptyConsultDate__c: oppty.OpptyConsultDate__c
            }));
            this.sales = undefined;
            this.oppties = undefined;
        }).catch(error => {
            this.error = error;
        });
    }
}

    //각 행 클릭시 해당 레코드로 이동
    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        if (action.name === 'view_details') {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                objectApiName: 'Oppty__c', 
                actionName: 'view'
            }
        });
    }
}
}