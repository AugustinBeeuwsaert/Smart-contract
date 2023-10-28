Augustin Beeuwsaert Grp BUT-S5 L


Description
Ce dépôt Github contient un contrat intelligent (smart contract) en Solidity pour la gestion d'un processus de vote au sein d'une petite organisation.

Les principales caractéristiques et fonctionnalités du contrat sont les suivantes :

Les utilisateurs inscrits peuvent proposer des idées pendant la session d'enregistrement des propositions.
Les votes ne sont pas confidentiels pour les utilisateurs ajoutés à la liste blanche, chaque votant peut consulter les votes des autres.
Le vainqueur est déterminé par une majorité simple, c'est-à-dire que la proposition qui reçoit le plus de votes l'emporte.
Le processus de vote est géré par un ensemble d'états définis dans une énumération, permettant un suivi clair du déroulement du vote.
Le contrat utilise la bibliothèque OpenZeppelin "Ownable" pour la gestion de l'administrateur du vote.
L'ajout de la fonctionnalité de vote quadratique permet aux participants ayant une préférence marquée pour une décision de recevoir des votes supplémentaires, avec un coût quadratique pour chaque vote supplémentaire.

Utilisation
Le dépôt contient le contrat intelligent en Solidity.

Clonez ce dépôt GitHub localement.
Compilez le contrat en utilisant le compilateur Solidity.
Déployez le contrat sur la blockchain Ethereum en utilisant un portefeuille compatible avec Ethereum.
Inscrivez les votants sur la liste blanche en tant qu'administrateur.
Démarrez les sessions d'enregistrement des propositions et de vote selon le processus souhaité.
Les votants peuvent soumettre des idées et voter en conséquence.
Le contrat déterminera le gagnant à la fin de la session de vote.

Ajoue de fonctionaliter 
Au niveaux de l'ajoue de nouvelle fonctionaliter, j'ai rajouter une fonction (hasVoterVoted) qui permet à quiconque de vérifier si un électeur spécifique a déjà voté en fournissant l'adresse de l'électeur en question. Elle renvoie true si l'électeur a déjà voté et false s'il n'a pas encore voté ou s'il n'est pas enregistré. J'ai également rajouter une fonction (resetVoterStatus) peut être appelée par le propriétaire du contrat pour réinitialiser le statut de vote d'un électeur en particulier. Elle est utile si vous souhaitez permettre au propriétaire du contrat de corriger d'éventuelles erreurs ou abus liés au statut de vote des électeurs.


Le lien vers le front de remix - etherum IDE : https://youtu.be/nut_Vq32jfY

Le lien vers la Dapp js : https://youtu.be/dUnJp-ysHNI (Je n'ai pas eu le temps de deployer la Dapp en public) Pour rappel je suis en parcourt B, Nous avions donc pas l'obligation de le faire. 




