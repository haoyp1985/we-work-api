import type { CSSProperties, Ref, TransitionProps } from 'vue';
import type { DialogProps } from './dialog';
export declare const useDialog: (props: DialogProps, targetRef: Ref<HTMLElement | undefined>) => {
    afterEnter: () => void;
    afterLeave: () => void;
    beforeLeave: () => void;
    handleClose: () => void;
    onModalClick: () => void;
    close: () => void;
    doClose: () => void;
    onOpenAutoFocus: () => void;
    onCloseAutoFocus: () => void;
    onCloseRequested: () => void;
    onFocusoutPrevented: (event: CustomEvent) => void;
    titleId: Ref<string>;
    bodyId: Ref<string>;
    closed: Ref<boolean>;
    style: import("vue").ComputedRef<CSSProperties>;
    overlayDialogStyle: import("vue").ComputedRef<CSSProperties>;
    rendered: Ref<boolean>;
    visible: Ref<boolean>;
    zIndex: Ref<number>;
    transitionConfig: import("vue").ComputedRef<TransitionProps | {
        name: import("element-plus/es/utils").EpPropMergeType<(new (...args: any[]) => string | TransitionProps) | (() => import("./dialog").DialogTransition) | ((new (...args: any[]) => string | TransitionProps) | (() => import("./dialog").DialogTransition))[], unknown, unknown>;
        onAfterEnter: () => void;
        onBeforeLeave: () => void;
        onAfterLeave: () => void;
    }>;
};
