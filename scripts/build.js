const fs = require('fs-extra');
const path = require('path');

const addonFolderName = 'AnglerAtlas'; // Replace with your addon folder name
const projectRoot = path.resolve(__dirname, '..');
const srcPath = path.join(projectRoot, 'src'); // src is the folder we copy from
const distPath = path.join(projectRoot, 'dist'); // dist is the folder we clear and copy to
const wowPath = 'D:/Program Files (x86)/WorldOfWarcraft/World of Warcraft/_Classic_era_/Interface/AddOns';

function clearExist(path) {
    if (fs.existsSync(path)) {
        // If the addon folder exists, delete it
        fs.removeSync(path);
        console.log(`* '${path}' deleted.`);
    }
}

function buildAddon() {
    console.log('**~');
    console.log('**Build...');
    // Copy addon files to WoW directory and the dist folder
    // clearExist(path.join(distPath, addonFolderName));
    // fs.copySync(srcPath, distPath);
    // console.log(`* '${path.join(distPath, addonFolderName)}' copy success.`);
    clearExist(path.join(wowPath, addonFolderName));
    fs.copySync(srcPath, wowPath);
    console.log(`* '${path.join(wowPath, addonFolderName)}' copy success.`);
    console.log('**~');
}

buildAddon();