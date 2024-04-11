import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import saveOppty from '@salesforce/apex/OpptyController.saveOppty';
import saveCuOppty from '@salesforce/apex/OpptyController.saveOppty';

export default class customerModal extends NavigationMixin(LightningElement) {
    @track isModalOpen = true; // 모달 초기 열림 상태
    @track isSaveButtonDisabled = true; // '저장' 버튼 초기 비활성화 상태
    @track consultationValue = ''; // 상담 내용 필드 값 초기화

    @api customerId;
    @api customerName; // 고객 이름 받기 위해 추가

    // 모달 타이틀 동적으로 변경하기 위한 계산된 속성
    get modalTitle() {
        return this.customerName ? `${this.customerName} 님 상담 생성` : '판매상담 생성';
    }

    // 모달 닫기 함수
    closeModal() {
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent('closemodal'));
    }

    // 입력 필드 값 변경 이벤트 처리
    handleInputChange(event) {
        this.consultationValue = event.target.value;
        // 입력 필드가 비어있지 않다면 '저장' 버튼 활성화
        this.isSaveButtonDisabled = !this.consultationValue;
    }

    // 판매 저장 함수
    saveOppties() {
        if (this.consultationValue && this.customerId) { // 입력값과 고객 ID 확인
            // saveCuOppty 메서드 호출, 고객 ID를 포함한 파라미터 전달
            console.log(this.customerId);
            saveCuOppty({ 
                oppty: { 
                    'OpptySalesConsultation__c': this.consultationValue, 
                    'CustomerID__c': this.customerId // 고객 ID 추가
                } 
            })
            .then(result => {
                this.closeModal(); // 모달 닫기
                // 저장 후 해당 기회의 레코드 페이지로 이동
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result, // 저장된 기회의 ID를 가져와 이동
                        actionName: 'view'
                    }
                });
            })
            .catch(error => {
                console.error("error=> ", error);
            });
        } else if (this.consultationValue) { // 고객 ID 없이 consultationValue만 있는 경우
            saveOppty({ oppty: { 'OpptySalesConsultation__c': this.consultationValue } }) // 기존 로직 유지
                .then(result => {
                    this.closeModal(); // 모달 닫기
                    // 저장 후 해당 기회의 레코드 페이지로 이동
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: result, // 저장된 기회의 ID를 가져와 이동
                            actionName: 'view'
                        }
                    });
                })
                .catch(error => {
                    console.error("error=> ", error);
                });
        }
    }

    
}