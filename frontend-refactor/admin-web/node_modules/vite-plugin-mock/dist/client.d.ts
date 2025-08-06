import { b as MockMethod } from './types-b01b7736.js';
import 'http';

declare function createProdMockServer(mockList: any[]): Promise<void>;
declare function defineMockModule(fn: (config: {
    env: Record<string, any>;
    mode: string;
    command: 'build' | 'serve';
}) => Promise<MockMethod[]> | MockMethod[]): (config: {
    env: Record<string, any>;
    mode: string;
    command: 'build' | 'serve';
}) => Promise<MockMethod[]> | MockMethod[];

export { createProdMockServer, defineMockModule };
