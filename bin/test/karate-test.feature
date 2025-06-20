Feature: Marvel Characters API

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'jnaulava'
    * configure ssl = true

  Scenario: Obtener todos los personajes
    Given path username, 'api', 'characters'
    When method get
    Then status 200
    And match response == []

  Scenario: Obtener personaje por ID (exitoso)
    Given path username, 'api', 'characters', 1
    When method get
    Then status 200
    And match response == 
    """
    {
      id: 1,
      name: 'Iron Man',
      alterego: 'Tony Stark',
      description: 'Genius billionaire',
      powers: ['Armor', 'Flight']
    }
    """

  Scenario: Obtener personaje por ID (no existe)
    Given path username, 'api', 'characters', 999
    When method get
    Then status 404
    And match response == { error: 'Character not found' }

  Scenario: Crear personaje (exitoso)
    Given path username, 'api', 'characters'
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response ==
    {
      id: '#number',
      name: 'Iron Man',
      alterego: 'Tony Stark',
      description: 'Genius billionaire',
      powers: ['Armor', 'Flight']
    }

  Scenario: Crear personaje (nombre duplicado)
    Given path username, 'api', 'characters'
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Otro",
      "description": "Otro",
      "powers": ["Armor"]
    }
    """
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response == { error: 'Character name already exists' }

  Scenario: Crear personaje (faltan campos requeridos)
    Given path username, 'api', 'characters'
    And request
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response ==
    {
      name: 'Name is required',
      alterego: 'Alterego is required',
      description: 'Description is required',
      powers: 'Powers are required'
    }

  Scenario: Actualizar personaje (exitoso)
    Given path username, 'api', 'characters', 1
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """
    And header Content-Type = 'application/json'
    When method put
    Then status 200
    And match response ==
    {
      id: 1,
      name: 'Iron Man',
      alterego: 'Tony Stark',
      description: 'Updated description',
      powers: ['Armor', 'Flight']
    }

  Scenario: Actualizar personaje (no existe)
    Given path username, 'api', 'characters', 999
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """
    And header Content-Type = 'application/json'
    When method put
    Then status 404
    And match response == { error: 'Character not found' }

  Scenario: Eliminar personaje (exitoso)
    Given path username, 'api', 'characters', 1
    When method delete
    Then status 204

  Scenario: Eliminar personaje (no existe)
    Given path username, 'api', 'characters', 999
    When method delete
    Then status 404
    And match response == { error: 'Character not found' }