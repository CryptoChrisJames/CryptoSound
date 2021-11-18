const currentEnv = () => {
    if(process.env.NUXT_ENV_ENVIRONMENT) {
        return process.env.NUXT_ENV_ENVIRONMENT;
    } else {
        return 'dev';
    }
};

const currentContentfulToken = () => {
    return process.env.NUXT_ENV_CONTENTFUL_TOKEN;
};

const currentContentfulSpace = () => {
    return process.env.NUXT_ENV_CONTENTFUL_SPACE;
};

const currentContentfulEnv = () => {
    return process.env.NUXT_ENV_CONTENTFUL_ENV;
};

const firebaseAPIKey = () => {
    return process.env.NUXT_ENV_FIREBASE_API_KEY;
};

const firebaseAuthDomain = () => {
    return process.env.NUXT_ENV_FIREBASE_AUTH_DOMAIN;
};

const firebaseProjectID = () => {
    return process.env.NUXT_ENV_FIREBASE_PROJECT_ID;
};

const firebaseStorageBucket = () => {
    return process.env.NUXT_ENV_FIREBASE_STORAGE_BUCKET;
};

const firebaseMessagingSenderID = () => {
    return process.env.NUXT_ENV_FIREBASE_MESSAGING_SENDER_ID;
};

const firebaseAppID = () => {
    return process.env.NUXT_ENV_FIREBASE_APP_ID;
};

const firebaseMeasurementID = () => {
    return process.env.NUXT_ENV_FIREBASE_MEASUREMENT_ID;
};


export default {
    currentEnv,
    currentContentfulToken,
    currentContentfulSpace,
    currentContentfulEnv,
    firebaseAPIKey,
    firebaseAppID,
    firebaseAuthDomain,
    firebaseMeasurementID,
    firebaseMessagingSenderID,
    firebaseProjectID,
    firebaseStorageBucket,
};