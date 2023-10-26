Ce fichier décrit chaque fonction du contrat "Voting" et explique comment elles sont utilisées.

registerVoter(address _voterAddress)

Description : Cette fonction permet à l'administrateur d'inscrire un électeur en utilisant son adresse Ethereum.
Variable requise : _voterAddress - L'adresse Ethereum de l'électeur à inscrire.
Ordre d'utilisation : Vous pouvez appeler cette fonction pour inscrire un électeur avant de démarrer la session d'enregistrement des propositions.
startProposalsRegistration(uint _blocksToClose)

Description : Cette fonction démarre la session d'enregistrement des propositions avec une limite de temps définie en blocs.
Variable requise : _blocksToClose - Le nombre de blocs à attendre avant de clôturer la session d'enregistrement.
Ordre d'utilisation : Appelez cette fonction après avoir inscrit tous les électeurs.
endProposalsRegistrationIfTimeExpired()

Description : Cette fonction clôture la session d'enregistrement des propositions si la limite de temps en blocs est écoulée.
Variable requise : Aucune variable requise.
Ordre d'utilisation : Appelez cette fonction pour vérifier si la session d'enregistrement doit être clôturée en raison de la limite de temps.
registerProposal(string memory _description)

Description : Cette fonction permet à un électeur inscrit d'enregistrer une proposition.
Variable requise : _description - La description de la proposition.
Ordre d'utilisation : Les électeurs peuvent appeler cette fonction pendant la session d'enregistrement des propositions.
startVotingSession(uint _blocksToClose)

Description : Cette fonction démarre la session de vote avec une limite de temps définie en blocs.
Variable requise : _blocksToClose - Le nombre de blocs à attendre avant de clôturer la session de vote.
Ordre d'utilisation : Appelez cette fonction après avoir clôturé la session d'enregistrement des propositions.
endVotingSessionIfTimeExpired()

Description : Cette fonction clôture la session de vote si la limite de temps en blocs est écoulée.
Variable requise : Aucune variable requise.
Ordre d'utilisation : Appelez cette fonction pour vérifier si la session de vote doit être clôturée en raison de la limite de temps.
vote(uint _proposalId)

Description : Cette fonction permet à un électeur inscrit de voter pour une proposition.
Variable requise : _proposalId - L'ID de la proposition pour laquelle voter.
Ordre d'utilisation : Les électeurs peuvent appeler cette fonction pendant la session de vote.
closeVotingSession()

Description : Cette fonction clôture la session de vote et détermine la proposition gagnante.
Variable requise : Aucune variable requise.
Ordre d'utilisation : Appelez cette fonction après la session de vote pour déterminer le gagnant.
getWinner()

Description : Cette fonction renvoie l'ID de la proposition gagnante.
Variable requise : Aucune variable requise.
Ordre d'utilisation : Vous pouvez appeler cette fonction pour obtenir l'ID de la proposition gagnante après avoir clôturé la session de vote.
voteAgainst(uint _proposalId)

Description : Cette fonction permet à un électeur inscrit de voter contre une proposition.
Variable requise : _proposalId - L'ID de la proposition à voter contre.
Ordre d'utilisation : Les électeurs peuvent appeler cette fonction pendant la session de vote.