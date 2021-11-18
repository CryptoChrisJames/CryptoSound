import config from '../config.js';
import { initializeApp, getApps } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';

const firebaseConfig = {
    apiKey: config.firebaseAPIKey(),
    authDomain: config.firebaseAuthDomain(),
    projectId: config.firebaseProjectID(),
    storageBucket: config.firebaseStorageBucket(),
    messagingSenderId: config.firebaseMessagingSenderID(),
    appId: config.firebaseAppID(),
    measurementId: config.firebaseMeasurementID()
};

let firebaseApp = null;
const apps = getApps();

if(!apps.length) {
    firebaseApp = initializeApp(firebaseConfig);
} else {
    firebaseApp = apps[0];
}

export default ({store}, inject) => {
    const signIn = async (email, password) => {
        return await signInWithEmailAndPassword(getAuth(), email, password);
    };

    inject('firebase', {
        signIn,
    });
};