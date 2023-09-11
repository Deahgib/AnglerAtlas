const fs = require('fs-extra');
const path = require('path');
const packageJson = require('../package.json'); // Load package.json
const archiver = require('archiver');

const addonFolderName = 'AnglerAtlas'; // Replace with your addon folder name
const projectRoot = path.resolve(__dirname, '..');
// Define source path and WoW Addons path
const srcPath = path.join(projectRoot, 'src'); // src is the folder we copy from
const distPath = path.join(projectRoot, 'dist'); // dist is the folder we clear and copy to


// Read version and classicInterfaceVersion from package.json
const version = packageJson.version;
const classicInterfaceVersion = packageJson.classicInterfaceVersion;
console.log(`**~`);
// Update .toc file with version information
function updateTocFile(tocFilePath, version, classicInterfaceVersion) {
    const tocContents = fs.readFileSync(tocFilePath, 'utf8');
    const updatedTocContents = tocContents
        .replace(/^## Version:.*$/m, `## Version: ${version}`)
        .replace(/^## Interface:.*$/m, `## Interface: ${classicInterfaceVersion}`);
    fs.writeFileSync(tocFilePath, updatedTocContents, 'utf8');
    console.log(`* Updated ${path.basename(tocFilePath)} with version ${version} and Interface ${classicInterfaceVersion}`);
}


function deployAddon() {
    // Update .toc file with version information for AnglerAtlas and AnglerAtlas-Classic
    const tocFilePath = path.join(srcPath, `${addonFolderName}/${addonFolderName}.toc`);
    updateTocFile(tocFilePath, version, classicInterfaceVersion);
    const tocFilePathClassic = path.join(srcPath, `${addonFolderName}/${addonFolderName}-Classic.toc`);
    // updateTocFile(tocFilePathClassic, version, classicInterfaceVersion);
    // Create -Classic.toc file for AnglerAtlas-Classic
    fs.copyFileSync(tocFilePath, tocFilePathClassic);

    // Build a zip of the addon src folder
    const zipFileName = `${addonFolderName}-${version}.zip`;
    const zipFilePath = path.join(distPath, zipFileName);
    
    if (fs.existsSync(zipFilePath)) {
        fs.removeSync(zipFilePath);
        console.log(`* Clear old ${zipFileName}`);
    }

    const output = fs.createWriteStream(zipFilePath);
    const archive = archiver('zip', {
        zlib: { level: 9 }, // Set compression level to maximum
    });

    // Pipe archive data to the output file
    output.on('close', () => {
        console.log(`* Created ${zipFileName}`);
        console.log('**~');
    });

    archive.on('error', (err) => {
        throw err;
    });


    archive.pipe(output);
    archive.directory(srcPath, false);
    archive.finalize();
}
deployAddon();
