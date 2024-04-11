import { LightningElement, track } from 'lwc';
import searchNameVocs from '@salesforce/apex/VocNameController.searchNameVocs';
import { NavigationMixin } from 'lightning/navigation';
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
    @track customerName = '';
    @track vocRecords;
    @track selectedCustomerId;
    @track isCreateEnabled = true;
    columns = COLUMNS;

    handleCustomerNameChange(event) {
        this.customerName = event.target.value;
    }

    searchCustomers() {
        searchNameVocs({ customerName: this.customerName })
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
