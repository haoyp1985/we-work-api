import { UseDraggableOptions } from './useDraggable';
interface IProps extends UseDraggableOptions<any> {
    modelValue: any[];
    tag?: string;
    target?: string;
}
export declare const VueDraggable: import("vue").DefineComponent<IProps, {}, {}, {}, {}, import("vue").ComponentOptionsMixin, import("vue").ComponentOptionsMixin, {}, string, import("vue").VNodeProps & import("vue").AllowedComponentProps & import("vue").ComponentCustomProps, Readonly<IProps>, {}, {}>;
export {};
