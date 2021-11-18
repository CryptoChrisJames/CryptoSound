import config from '../config';
const contentful = require('contentful');

export default ({ store }, inject) => {
    const contenfulConfig = {
        space: config.currentContentfulSpace(),
        accessToken: config.currentContentfulToken(),
        environment: config.currentContentfulEnv(),
    };

    const client = () => {
        return contentful.createClient(contenfulConfig);
    };

    const getLogo = async () => {
        const logoObj = await client().getEntries({
            content_type: 'logo'
        });
        return logoObj.items[0].fields.logo.fields.file.url;
    };

    const getVideoHeaderLinks = async () => {
        const videoObj = await client().getEntries({
            content_type: 'heroVideo'
        });
        return videoObj.items.map(obj => {
            return {
                page: obj.fields.page,
                link: obj.fields.herovideo
            };
        });
    };

    const getPromotionCollections = async () => {
        const collectionObj = await client().getEntries({
            content_type: 'promotedCollections'
        });
        return collectionObj.items.map(obj => {
            return {
                promotionName: obj.fields.name,
                cover: obj.fields.collections[0].fields.cover.fields.file.url,
                name: obj.fields.collections[0].fields.name,
                promotionDesc: obj.fields.collections[0].fields.promotionalDescription
                    .content[0].content[0].value
            };
        });
    }

    const getCollections = async () => {
        return await client().getEntries({
            content_type: 'collection'
        });
    }

    inject('contentful', {
        getLogo,
        getVideoHeaderLinks,
        getPromotionCollections,
        getCollections,
    });
};

