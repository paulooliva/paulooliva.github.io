<?php
        $dom = new DOMDocument('1.0');

        if (file_exists('teams.xml'))
            $dom->load("teams.xml");
        else
            exit('Failed to open teams.xml.');

        $root = $dom->documentElement; 
        
        $team = $dom->createElement('team');
        $root->appendChild($team);

        $name = $dom->createElement('team_name', $_POST['name']);
        $team->appendChild($name);
        
        $languages = $dom->createElement('languages', $_POST['languages']);
        $team->appendChild($languages);

        $dom->formatOutput = true;
        $dom->save('teams.xml');

        echo "Team details uploaded";
?>