import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCustomerOppties from '@salesforce/apex/CustomerOpptyController.getCustomerOppties';

export default class CustomerOppty extends NavigationMixin(LightningElement) {
    @api customerId;
    @track oppties;
    @track isModalOpen = false; // 모달 상태를 관리하는 변수
    columns = [
        { label: '판매 이름', fieldName: 'Name', type: 'button', typeAttributes: { label: { fieldName: 'Name' },name: 'view_details', variant: 'base' } },
        { label: '상담 내역', fieldName: 'OpptySalesConsultation__c', type: 'text' },
        { label: '상담 일자', fieldName: 'OpptyConsultDate__c', type: 'date' },
        { label: '판매 상태', fieldName: 'OpptyStageGroup__c', type: 'text' }
    ];

    @wire(getCustomerOppties, { customerId: '$customerId' })
    wiredOppties({ error, data }) {
        if (data) {
            console.log(data);
            this.oppties = data;
        } else if (error) {
            this.oppties = undefined;
        }
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        if (action.name === 'view_details') {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id,
                    actionName: 'view'
                }
            });
        }
    }

    // "New" 버튼 클릭 핸들러
    handleNewCustomer() {
        this.isModalOpen = true; // 모달을 열기 위해 상태 변경
    }

    // 모달 닫기 핸들러
    handleCloseModal() {
        this.isModalOpen = false; // 모달을 닫기 위해 상태 변경
    }

    // 모달 내에서 "저장"을 처리하는 메서드 (예시)
    saveOppties() {
        // 저장 로직을 구현합니다.
        this.closeModal(); // 저장 후 모달을 닫습니다.
    }
}