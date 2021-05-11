# TUTO Udemy Marketplace NFT

## Sommaire

## Introduction
Petit tutorial pour acquérir les bases pour créer sa première DApp. 
Tech:
- Solidity
- Truffle Suite (Ganache, Truffle, Drizzle)
- OpenZeppelin
- React
- Redux

Création d'une marketplace de NFT

## Fonctionnalités
 - Mint de NFTs
 - Achat-vente de NFTs
 - Update de NFts (setPrice, URI)

 ## Installation & Lancement
 ### Lancer un client Ethereum
L'utilisation de Ganache est **recommandée**, téléchargez [Ganache] et lancez l'application. Cela lancera une blockchain local sur le port 7545.

Ou vous pouvez utiliser Ganache-CLI (s'il n'est pas encore installé) avec `npm install -g ganache-cli` puis `ganache-cli` qui fonctionnera sur le port 8545.

L'installation de Truffle en global est **recommandée** `npm install -g truffle`

### Déployer les contrats
Déployer les contrats sur Ganache.

```sh
truffle deploy --network develop
```

### Installer les dépendances
Lancez les commandes suivantes dans le terminal :
```sh
npm install
cd client
npm install
```

### Lancer les tests
```sh
truffle test
```