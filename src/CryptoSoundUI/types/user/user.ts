export class User {
    email: string;
    accessToken: string;
    uid: string;
    
    constructor(email: string, accessToken: string, uid: string) {
        this.email = email,
        this.accessToken = accessToken,
        this.uid = uid
    }
}
