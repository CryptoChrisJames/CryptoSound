import { uuid } from 'vue-uuid';

const parsePromotions = (promotions: Array<any>): any => {
    return promotions.map((p) => {
        return {
            cover: p.cover,
            name: p.name,
            promotionDesc: p.promotionDesc,
            promotionName: p.promotionName
        };
    });
};

const parseCollections = (collections: Array<any>): any => {
    return collections.map((c) => {
        return {
            id: uuid.v4(),
            name: c.fields.name,
            creator: c.fields.collectionCreator,
            type: c.fields.collectionType,
            cover: c.fields.cover.fields.file.url,
            description: c.fields.description.content[0].content[0].value,
            digitalAsset: c.fields.digitalAsset.fields.file.url,
            promotionalDescription: c.fields.promotionalDescription.content[0].content[0].value,
            tracks: parseTracks(c.fields.tracks),
            price: c.fields.price,
            productId: c.fields.productId.id
        };
    });
};

const parseTracks = (tracks: Array<any>): any => {
    return tracks.map((t) => {
        return {
            id: uuid.v4(),
            name: t.fields.name,
            url: t.fields.file.fields.file.url,
            price: t.fields.price,
            productId: t.fields.productId.id
        };
    });
};

export default {
    parsePromotions,
    parseCollections,
    parseTracks,
};