// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IVerifier {
    /**
        The proof should verify that:
            - relayerHash is hash(relayerRand) where relayerRand is a randomness
            - emailAddressPointer is hash(relayerRand, emailAddress)
            - viewingKeyCommitment is hash(viewingKey, emailAddress, relayerHash)
                where viewingKey is a randomness
            - walletSalt is hash(viewingKey, 0)

        Note: relayerHash was previously registered by the relayer
     */
    function verifyAccountCreationProof(
        bytes32 relayerHash,
        bytes32 emailAddressPointer,
        bytes32 viewingKeyCommitment,
        bytes32 walletSalt,
        bytes memory proof
    ) external view returns (bool);

    /**
        This proof will verify that:
            - relayer received an email from the sender
            - the same email address and the relayer's hash
              is used to calculate the poitner and VK commitment
            - sender's email was DKIM signed with public key whose 
              hash is `dkimPublicKeyHash`
            - email had a header `x-reply-to` whose value was viewingKey

        Note: relayerHash, emailAddressPointer, viewingKeyCommitment are previously
        registered by the relayer. 
        dkimPublicKeyHash is from the stored mapping against emailDomain.

        TODO: isEmailNullifier needed? PSI registration needed during intialization?
     */
    function verifyAccountInitializaionProof(
        bytes32 relayerHash,
        bytes32 emailAddressPointer,
        bytes32 viewingKeyCommitment,
        string memory emailDomain,
        bytes32 dkimPublicKeyHash,
        bytes memory proof
    ) external view returns (bool);

    /**
        The proof should verify that:
            - relayerHash is hash(relayerRand) where relayerRand is a randomness
            - emailAddressPointer is hash(relayerRand, emailAddress)
            - viewingKeyCommitment is hash(viewingKey, emailAddress, relayerHash)
                where viewingKey is a randomness
            - walletSalt is hash(viewingKey, 0)

        Note: relayerHash was previously registered by the relayer
     */
    function verifyRecipientAccountProof(
        bytes32 relayerHash,
        bytes32 emailAddressPointer,
        bytes32 viewingKeyCommitment,
        bytes32 walletSalt,
        bytes32 emailAddressWitness,
        bytes memory proof
    ) external view returns (bool);

    /**
        This proof will verify that:
            - relayer received an email from seder which contained the maskedSubjectStr
            and DKIM signed by public key whose hash is dkimPublicKeyHash
            - senderEmailAddressPointer, senderViewingKeyCommitment are calculated
            from the same emailAddress
            - emailNullifier is hash of the email headers
            - hasRecipient is true if the subject has a recipient
            - isRecipientExternal is true if the recipient is ETH address instead of email 
            - recipientEmailAddressWitness is hash of emailAddress and a randomness

        Note: relayerHash, senderEmailAddressPointer, senderViewingKeyCommitment are previously
        registered by the relayer. dkimPublicKeyHash is from the stored mapping.
     */
    function verifyEmailProof(
        bytes32 senderRelayerHash,
        bytes32 senderEmailAddressPointer,
        bytes32 senderViewingKeyCommitment,
        bool hasRecipient,
        bool isRecipientExternal,
        bytes32 recipientEmailAddressWitness,
        string memory maskedSubjectStr,
        bytes32 emailNullifier,
        string memory senderEmailDomain,
        bytes32 dkimPublicKeyHash,
        bytes memory proof
    ) external view returns (bool);
}