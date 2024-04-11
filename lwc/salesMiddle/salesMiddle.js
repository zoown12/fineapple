import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class App extends LightningElement {
    @track selectedCustomerId; // 전달받은 CustomerId 데이터를 저장함.
    @track isCustomerOpptyVisible = true; // 고객 기회 컴포넌트 표시 여부를 제어하는 새로운 상태 변수

    handleCustomerSelect(event) {
        this.selectedCustomerId = event.detail.customerId;
        this.isCustomerOpptyVisible = true; // 고객이 선택되면 고객 기회 컴포넌트를 다시 표시
    }

    handleSearchKeyEmpty() {
        this.selectedCustomerId = null; // 검색 키워드가 비어있음을 처리
        this.isCustomerOpptyVisible = false; // 고객 기회 컴포넌트를 화면에서 숨김
    }


}