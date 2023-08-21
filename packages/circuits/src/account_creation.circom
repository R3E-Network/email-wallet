pragma circom 2.1.5;

include "circomlib/circuits/poseidon.circom";
include "@zk-email/circuits/helpers/extract.circom";
include "./utils/constants.circom";
include "./utils/email_addr_pointer.circom";
include "./utils/viewing_key_commit.circom";
include "./utils/email_addr_wtns.circom";
include "./utils/wallet_salt.circom";

template AccountCreation() {
    var email_max_bytes = email_max_bytes_const();
    signal input email_addr[email_max_bytes];
    signal input relayer_rand;
    signal input vk;
    signal input cm_rand;
    signal output relayer_rand_hash;
    signal output pointer;
    signal output vk_commit;
    signal output wallet_salt;
    signal output vk_wtns;

    signal relayer_rand_hash_input[1];
    relayer_rand_hash_input[0] <== relayer_rand;
    relayer_rand_hash <== Poseidon(1)(relayer_rand_hash_input);
    var num_email_addr_ints = compute_ints_size(email_max_bytes);
    signal email_addr_ints[num_email_addr_ints] <== Bytes2Ints(email_max_bytes)(email_addr);
    pointer <== EmailAddrPointer(num_email_addr_ints)(relayer_rand, email_addr_ints);
    vk_commit <== ViewingKeyCommit(num_email_addr_ints)(vk, email_addr_ints, relayer_rand_hash);
    wallet_salt <== WalletSalt()(vk, 0);
    signal vk_wtns_input[2];
    vk_wtns_input[0] <== cm_rand;
    vk_wtns_input[1] <== vk;
    vk_wtns <== Poseidon(2)(vk_wtns_input);
}

component main  = AccountCreation();