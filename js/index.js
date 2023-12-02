"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const eth_typed_data_1 = __importDefault(require("eth-typed-data"));
const bignumber_js_1 = __importDefault(require("bignumber.js"));
const ethUtil = __importStar(require("ethereumjs-util"));
const ethers_1 = require("ethers");
const axios_1 = __importDefault(require("axios"));
/*
 * Safe relay service example
 * * * * * * * * * * * * * * * * * * * */
const gnosisEstimateTransaction = (safe, tx) => __awaiter(void 0, void 0, void 0, function* () {
    console.log(JSON.stringify(tx));
    try {
        const resp = yield axios_1.default.post(`https://safe-relay.rinkeby.gnosis.pm/api/v2/safes/${safe}/transactions/estimate/`, tx);
        console.log(resp.data);
        return resp.data;
    }
    catch (e) {
        console.log(JSON.stringify(e.response.data));
        throw e;
    }
});
const gnosisSubmitTx = (safe, tx) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const resp = yield axios_1.default.post(`https://safe-relay.rinkeby.gnosis.pm/api/v1/safes/${safe}/transactions/`, tx);
        console.log(resp.data);
        return resp.data;
    }
    catch (e) {
        console.log(JSON.stringify(e.response.data));
        throw e;
    }
});
const { utils } = ethers_1.ethers;
const execute = (safe, privateKey) => __awaiter(void 0, void 0, void 0, function* () {
    const safeDomain = new eth_typed_data_1.default({
        verifyingContract: safe,
    });
    const SafeTx = safeDomain.createType('SafeTx', [
        { type: "address", name: "to" },
        { type: "uint256", name: "value" },
        { type: "bytes", name: "data" },
        { type: "uint8", name: "operation" },
        { type: "uint256", name: "safeTxGas" },
        { type: "uint256", name: "baseGas" },
        { type: "uint256", name: "gasPrice" },
        { type: "address", name: "gasToken" },
        { type: "address", name: "refundReceiver" },
        { type: "uint256", name: "nonce" },
    ]);
    const to = utils.getAddress("0x0ebd146ffd9e20bf74e374e5f3a5a567a798177e");
    const baseTxn = {
        to,
        value: "1000",
        data: "0x",
        operation: "0",
    };
    console.log(JSON.stringify({ baseTxn }));
    const { safeTxGas, baseGas, gasPrice, gasToken, refundReceiver, lastUsedNonce } = yield gnosisEstimateTransaction(safe, baseTxn);
    const txn = Object.assign(Object.assign({}, baseTxn), { safeTxGas,
        baseGas,
        gasPrice,
        gasToken, nonce: lastUsedNonce === undefined ? 0 : lastUsedNonce + 1, refundReceiver: refundReceiver || "0x0000000000000000000000000000000000000000" });
    console.log({ txn });
    const safeTx = new SafeTx(Object.assign(Object.assign({}, txn), { data: utils.arrayify(txn.data) }));
    const signer = (data) => __awaiter(void 0, void 0, void 0, function* () {
        let { r, s, v } = ethUtil.ecsign(data, ethUtil.toBuffer(privateKey));
        return {
            r: new bignumber_js_1.default(r.toString('hex'), 16).toString(10),
            s: new bignumber_js_1.default(s.toString('hex'), 16).toString(10),
            v
        };
    });
    const signature = yield safeTx.sign(signer);
    console.log({ signature });
    const toSend = Object.assign(Object.assign({}, txn), { dataGas: baseGas, signatures: [signature] });
    console.log(JSON.stringify({ toSend }));
    const { data } = yield gnosisSubmitTx(safe, toSend);
    console.log({ data });
    console.log("Done?");
});
// This example uses the relay service to execute a transaction for a Safe
execute("<safe>", "<0x_signer_private_key>");
/*
 * Safe transaction service example
 * * * * * * * * * * * * * * * * * * * */
const gnosisProposeTx = (safe, tx) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const resp = yield axios_1.default.post(`https://safe-transaction.rinkeby.gnosis.io/api/v1/safes/${safe}/transactions/`, tx);
        console.log(resp.data);
        return resp.data;
    }
    catch (e) {
        if (e.response)
            console.log(JSON.stringify(e.response.data));
        throw e;
    }
});
const submit = (safe, sender, privateKey) => __awaiter(void 0, void 0, void 0, function* () {
    const safeDomain = new eth_typed_data_1.default({
        verifyingContract: safe,
    });
    const SafeTx = safeDomain.createType('SafeTx', [
        { type: "address", name: "to" },
        { type: "uint256", name: "value" },
        { type: "bytes", name: "data" },
        { type: "uint8", name: "operation" },
        { type: "uint256", name: "safeTxGas" },
        { type: "uint256", name: "baseGas" },
        { type: "uint256", name: "gasPrice" },
        { type: "address", name: "gasToken" },
        { type: "address", name: "refundReceiver" },
        { type: "uint256", name: "nonce" },
    ]);
    const to = utils.getAddress("0x0ebd146ffd9e20bf74e374e5f3a5a567a798177e");
    const baseTxn = {
        to,
        value: "1000",
        data: "0x",
        operation: "0",
    };
    console.log(JSON.stringify({ baseTxn }));
    // Let the Safe service estimate the tx and retrieve the nonce
    const { safeTxGas, lastUsedNonce } = yield gnosisEstimateTransaction(safe, baseTxn);
    const txn = Object.assign(Object.assign({}, baseTxn), { safeTxGas, 
        // Here we can also set any custom nonce
        nonce: lastUsedNonce === undefined ? 0 : lastUsedNonce + 1, 
        // We don't want to use the refund logic of the safe to lets use the default values
        baseGas: 0, gasPrice: 0, gasToken: "0x0000000000000000000000000000000000000000", refundReceiver: "0x0000000000000000000000000000000000000000" });
    console.log({ txn });
    const safeTx = new SafeTx(Object.assign(Object.assign({}, txn), { data: utils.arrayify(txn.data) }));
    const signer = (data) => __awaiter(void 0, void 0, void 0, function* () {
        let { r, s, v } = ethUtil.ecsign(data, ethUtil.toBuffer(privateKey));
        return ethUtil.toRpcSig(v, r, s);
    });
    const signature = yield safeTx.sign(signer);
    console.log({ signature });
    const toSend = Object.assign(Object.assign({}, txn), { sender, contractTransactionHash: "0x" + safeTx.signHash().toString('hex'), signature: signature });
    console.log(JSON.stringify({ toSend }));
    const { data } = yield gnosisProposeTx(safe, toSend);
    console.log({ data });
    console.log("Done?");
});
// This example uses the transaction service to propose a transaction to the Safe Multisig interface
submit("<safe>", "<0x_signer_address>", "<0x_signer_private_key>");
