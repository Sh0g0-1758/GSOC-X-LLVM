async function fetchJsonFiles() {
    const response = await fetch('/results/');
    const text = await response.text();
    const parser = new DOMParser();
    const doc = parser.parseFromString(text, 'text/html');
    const links = Array.from(doc.querySelectorAll('a'));
    const jsonFiles = links
        .map(link => link.href.split('/').pop())
        .filter(file => file.endsWith('.json'));

    return jsonFiles;
}

function populateTable(filenames) {
    const tableBody = document.getElementById('jsonTable').getElementsByTagName('tbody')[0];
    filenames.forEach(filename => {
        const row = document.createElement('tr');
        const cell = document.createElement('td');
        const link = document.createElement('a');
        link.href = `graph.html?file=${filename}`;
        link.textContent = filename.replace('.json', '');
        cell.appendChild(link);
        row.appendChild(cell);
        tableBody.appendChild(row);
    });
}

fetchJsonFiles().then(filenames => {
    populateTable(filenames);
}).catch(error => {
    console.error('Error fetching JSON files:', error);
});