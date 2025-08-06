import { V as ViteMockOptions } from './types-b01b7736.js';
export { M as MethodType, c as MockConfig, b as MockMethod, a as Recordable, R as RespThisType } from './types-b01b7736.js';
import { Plugin } from 'vite';
import 'http';

declare function viteMockServe(opt?: ViteMockOptions): Plugin;

export { ViteMockOptions, viteMockServe };
