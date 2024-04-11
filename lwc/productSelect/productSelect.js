import { LightningElement, track, wire, api } from 'lwc';
import getProducts from '@salesforce/apex/ProductController.getProducts';
import createRecords from '@salesforce/apex/ProductController.createRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class productSelect extends LightningElement {
    @api recordId;
    @track quantity = 1;
    @track itemOptions = [];
    @track productGroupOptions = '노트북'
    @track selectedItemId;
    @track selectedProductGroupId;

    productGroupOptions = [
        { value: '노트북', label: '노트북'},
        {
            value: '주변기기',
            label: '주변기기',
        },
    ];


    //제품 리스트 가져오기
    @wire(getProducts, { productType: '$selectedProductGroupId' })
    products({error, data}) {
        if (data) {
            this.itemOptions = data.map(product => {
                return { label: product.Name, value: product.Id };
            });
        } else if (error) {
            console.error('Error fetching products:', error);
        }
    }

    handleProductGroupChange(event) {
        this.selectedProductGroupId = event.detail.value;
    }

    handleItemChange(event) {
        this.selectedItemId = event.detail.value;
    }

    handleQuantityChange(event) {
        this.quantity = parseInt(event.target.value, 10);
    }

    //추가 버튼 활성화 조건
    get isSaveDisabled() {
        const numericQuantity = this.quantity === '' ? NaN : +this.quantity;
        return isNaN(numericQuantity) || numericQuantity <= 0 || !this.selectedItemId;
    }
    

    //선택한 제품, 수량으로 레코드 생성
    saveRecords() {
        createRecords({ itemName: this.selectedItemId, quantity: this.quantity, parentId: this.recordId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '제품 추가 완료',
                        message: '선택한 제품을 추가했습니다.',
                        variant: 'success'
                    })
                );
                setTimeout(() => {
                    window.location.reload();
                }, 600);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}