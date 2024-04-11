import { LightningElement } from 'lwc';
import MY_PICTURE from '@salesforce/resourceUrl/gram'; // 'myPicture'는 업로드한 사진의 이름입니다.

export default class PictureComponent extends LightningElement {
    pictureUrl = MY_PICTURE; // 정적 리소스 URL을 JavaScript 프로퍼티에 할당
}