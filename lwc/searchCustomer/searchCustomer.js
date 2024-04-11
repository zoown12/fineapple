import { LightningElement, track, api } from 'lwc';
import searchCustomers from '@salesforce/apex/SearchCustomerController.searchCustomers';

export default class SearchCustomer extends LightningElement {
    searchKey = '';
    @track customers;
    @api noDataFoundMessage; // 데이터가 없을 때 메시지를 동적으로 바꿀 수 있게 만듬

    @track isModalOpen = false; // 모달 상태를 관리하는 변수
    
    columns = [
        { label: '고객 이름', fieldName: 'Name', type: 'button', // 고객 이름을 버튼으로 변경하여 클릭 가능하게 함
          typeAttributes: { label: { fieldName: 'Name' }, name: 'select_customer', variant: 'base' }},
        { label: '전화 번호', fieldName: 'Phone__c', type: 'phone' },
        { label: '고객 등급', fieldName: 'CustomerRank__c' , type: 'text'}
    ];

    // 입력값을 받을 때 마다 결과값을 출력해줌.
    handleInputChange(event) {
        this.searchKey = event.target.value;
        if (this.searchKey.length === 0) {
            this.customers = null;
            // 검색 키워드가 비어 있는 경우의 Custom Event 발생
            this.dispatchEvent(new CustomEvent('searchkeyempty'));
            return;
        }
        this.performSearch();
    }


    performSearch() {
        searchCustomers({ searchKey: this.searchKey })
            .then(result => {
                this.customers = result;
                if(result.length === 0){
                    // 데이터를 받아왔으나 결과가 비어 있는 경우, 메시지를 표시하도록 상태를 업데이트
                    this.noDataFoundMessage = "검색 결과가 없습니다.";
                }
            })
            .catch(error => {
                this.error = error;
                this.customers = null;
                this.noDataFoundMessage = "고객 정보 검색 중 오류가 발생했습니다."; // 오류 발생시 메시지 변경
            });
    }
    
    // 고객 이름 클릭 이벤트 핸들러
    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        switch (action.name) {
            case 'select_customer': // 이는 columns에서 정의한 typeAttributes와 일치해야 함
                this.selectCustomer(row);
                break;
            default:
                // 이곳에 기본 행동이 필요한 경우 코드를 추가할 수 있습니다.
                break;
        }
    }

    // 선택된 고객에 대한 처리
    selectCustomer(row) {
        // Custom event 생성 및 발송
        const selectedEvent = new CustomEvent('customerselect', { detail: { customerId: row.Id } });
        this.dispatchEvent(selectedEvent);
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