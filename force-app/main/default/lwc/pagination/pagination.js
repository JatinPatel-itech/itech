import { LightningElement,api } from 'lwc';

export default class Pagination extends LightningElement {

    @api currentPage;
    @api pageSize;
    @api totalRecords;

    get totalPages() {
        return Math.ceil(this.totalRecords / this.pageSize);
    }

    handleFirstPage() {
        this.dispatchEvent(new CustomEvent('paginate', { detail: { pageNumber: 1, pageSize: this.pageSize } }));
    }

    handlePreviousPage() {
        this.dispatchEvent(new CustomEvent('paginate', { detail: { pageNumber: this.currentPage - 1, pageSize: this.pageSize } }));
    }

    handleNextPage() {
        this.dispatchEvent(new CustomEvent('paginate', { detail: { pageNumber: this.currentPage + 1, pageSize: this.pageSize } }));
    }

    handleLastPage() {
        this.dispatchEvent(new CustomEvent('paginate', { detail: { pageNumber: this.totalPages, pageSize: this.pageSize } }));
        }


}