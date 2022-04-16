import { User } from '../types/user/user';

export const state = () => ({
    user: null as User,
});

export const mutations = {
    setCurrentUser(state: any, payload: User) {
        state.user = payload;
    }
};

