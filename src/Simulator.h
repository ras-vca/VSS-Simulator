/*
   The MIT License (MIT)

   Copyright (c) 2016 Lucas Borsatto Simão

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.
 */

#ifndef SIMULATOR_H_
#define SIMULATOR_H_

#include <Communications/StateSender.h>
#include "Communications/CommandReceiver.h"
#include "Header.h"

#include "Physics.h"
#include "RobotStrategy.h"
#include "RobotPhysics.h"
#include "strategies/Strategy.h"

#include "strategies/ModelStrategy.h"
#include "Arbiter.h"

// TODO: refatorar, viola pelo menos Single Responsability
class Simulator {
	struct GameState {
		vector<RobotStrategy*> robotStrategiesTeam;
		vector<RobotStrategy*> robotStrategiesAdv;
		bool sameState;

		GameState() : sameState( true ){
		};
	};

private:

	Arbiter arbiter;
	bool paused;

	int qtd_of_goals;
	bool develop_mode;
	int status_team_1;
	int status_team_2;
	int goals_team_1;
	int goals_team_2;

	Report report;
	bool finish_match;
	float timeStep;
	float handTime;
	int numRobotsTeam;
	vector<Command> commands;

	vss::IStateSender *stateSender;

	GameState* gameState;
	int loopBullet;

	Physics* physics;
	vector<ModelStrategy*> strategies;

	thread *thread_physics;
	thread *thread_strategies;
	thread *thread_receive_team1;
	thread *thread_receive_team2;
	thread *thread_receive_control;

	void updateWorld();
	void updateReport();
	btVector3 calcRelativePosition( btVector3 absPos, int attackDir );
	void calcRelativeWorld( vector<RobotStrategy*> robotStrategiesTeam, int attackDir );
	RobotStrategy* updateLocalPhysics( int id, RobotPhysics* bdRobot );

	btVector3 getRobotOrientation( RobotPhysics* robot );
	btVector3 getRobotPosition( RobotPhysics* robot );
	btVector3 getRobotVelocity( RobotPhysics* robot );

	float radianToDegree(float);
	float degreeToRadian(float);
public:

	Simulator();
	void runSimulator( int argc, char *argv[], ModelStrategy * strategyTeam, ModelStrategy * strategyAdv, bool fast_travel, int qtd_goal, bool develop_mode );

	void runPhysics();
	void runStrategies();
	void runSender();
	void runReceiveTeam1();
	void runReceiveTeam2();
	void runReceiveControl();

	btVector3 getBallPosition();
};

#endif
