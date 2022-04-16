export class User {
    email: string;
    isSignedIn: boolean;
    accessToken: string;
    
    constructor(email: string, accessToken: string) {
        this.email = email,
        this.isSignedIn = true,
        this.accessToken = accessToken
    }
}
