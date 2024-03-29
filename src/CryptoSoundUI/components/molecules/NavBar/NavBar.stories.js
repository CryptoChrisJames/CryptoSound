import navBar from './NavBar.vue';

export default {
    title: 'Navigation Bar',
};

export const NavBar = () => ({
    components: { navBar },
    template: `
        <div>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.14.0/css/all.min.css" integrity="sha512-1PKOgIY59xJ8Co8+NE6FZ+LOAZKjy+KY8iq0G4B3CyeY6wYHN3yt9PW0XpSriVlkMXe40PTKnXrLnZ9+fkDaog==" crossorigin="anonymous" />
            <navBar/>
        </div>
    `,
})