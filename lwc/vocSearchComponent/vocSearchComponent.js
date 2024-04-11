// vocSearchComponent.js
import { LightningElement, track,api } from 'lwc';
import searchVocs from '@salesforce/apex/VocController.searchVocs';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';

const COLUMNS = [
    { 
        label: '고객이름', 
        fieldName: 'NameLink', 
        type: 'button', // 여기서 사용자 정의 타입을 button으로 설정합니다.
        typeAttributes: {
        label: { fieldName: 'Name' }, // 데이터에서 Name 필드 값을 버튼의 라벨로 사용합니다.
        name: 'viewDetails',
        variant: 'base',
        },
    },
    { label: '전화번호', fieldName: 'Phone__c' },
    { label: '상담횟수', fieldName: 'Consult__c' },
    { label: 'Voc횟수', fieldName: 'Voc__c' },
    { label: '고객유형', fieldName: 'CustomerType__c' }
];
export default class SearchVocForCustomer extends NavigationMixin(LightningElement) {
    @api recordId;
    @track customerName = '';
    @track phoneNumber = '';
    @track vocRecords;
    @track selectedCustomerId;
    @track isCreateEnabled = true;
    columns = COLUMNS;

    handleModalContentChange() {
        // 모달 내부의 모든 입력 필드 중 고객 ID 필드를 찾아 값을 설정합니다.
        // 이 예에서는 'customer_id_field'를 고객 ID 필드의 class라고 가정합니다.
        const customerIdInputField = this.template.querySelector('.customer_id_field');
        if (customerIdInputField) {
            customerIdInputField.value = this.selectedCustomerId;
        }
    }

    handleCustomerNameChange(event) {
        this.customerName = event.target.value;
    }

    searchCustomers() {
        searchVocs({ customerName: this.customerName })
            .then(result => {
                this.vocRecords = result;
            })
            .catch(error => {
                console.error('Error retrieving Voc records', error);
            });
    }
    
    handlePhoneNumberChange(event) {
        this.phoneNumber = event.target.value;
    }

    searchVocsByPhoneNumber() {
        searchVocs({ phoneNumber: this.phoneNumber })
            .then(result => {
                if (result.length > 0) {
                    
                    // 검색 결과가 있다면, 첫 번째 고객의 ID를 저장합니다.
                     this.vocRecords = result;
                     for (let i = 0; i < result.length; i++) {
                        this.selectedCustomerId = result[i].Id;                 // Do something with phone value
                    }
                    this.isCreateEnabled = false;
                } else {
                    // 검색 결과가 없다면, 알림을 표시하거나 로직을 추가합니다.
                    this.selectedCustomerId = null;
                    this.isCreateEnabled = true;
                }
                // ...
            })
            .catch(error => {
                // 오류 처리 로직...
            });
    }
    //이름클릭을 통해 세부정보 페이지로 이동하게 하는 이벤트
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'viewDetails') {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id, // 여기서 row.Id는 CustomerCu__c 레코드의 ID를 나타냅니다.
                    objectApiName: 'CustomerCu__c', // 여기에 객체의 API 이름을 명시합니다.
                    actionName: 'view'
                },
            });
        }
    }

    @track isModalOpen = false;

    // 모달을 여는 메소드
    openCreateModal() {
        this.isModalOpen = true;
        // 모달을 여기서 열고, 이벤트를 통해 고객 ID를 lightning-record-edit-form에 전달합니다.
        if (this.selectedCustomerId) {
    
            // 기존 레코드 ID가 없다면 새로 생성할 때 필요한 초기값을 설정합니다.
            this.record = {
                fields: {
                    VocCustomerCuID__c: this.selectedCustomerId
                }
            };
        } else {
            // 알림을 표시하거나 사용자에게 검색을 먼저 하도록 지시합니다.
            // 예: "검색을 먼저 수행해 주세요."
        }
    }
    // 모달을 닫는 메소드
    closeModal() {
        this.isModalOpen = false;
    }
    
    handleSuccess(event) {
        // 선택된 고객 ID를 URL 인코딩된 문자열 형태로 `defaultFieldValues`에 설정
        //const defaultFieldValues = encodeURIComponent(`VocCustomerCuID__c=${this.selectedCustomerId}`);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'VoC__c',
                actionName: 'new'
            },
            state: {
                nooverride: '1',
                defaultFieldValues: `VocCustomerCuID__c=${this.selectedCustomerId}`
            }
        });
    }
}