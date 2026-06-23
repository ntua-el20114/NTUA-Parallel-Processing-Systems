#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include "mpi.h"
#include "utils.h"

int main(int argc, char ** argv) {
    int rank,size;
    int global[2],local[2]; //global matrix dimensions and local matrix dimensions (2D-domain, 2D-subdomain)
    int global_padded[2];   //padded global matrix dimensions (if padding is not needed, global_padded=global)
    int grid[2];            //processor grid dimensions
    int i,j,t;
    int global_converged=0,converged=0; //flags for convergence, global and per process
    MPI_Datatype dummy;     //dummy datatype used to align user-defined datatypes in memory
    double omega; 			//relaxation factor - useless for Jacobi

    struct timeval tts,ttf,tcs,tcf,tccs,tccf;   //Timers: total-> tts,ttf, computation -> tcs,tcf
    double ttotal=0,tcomp=0,total_time,comp_time;
    #ifdef TEST_CONV
    double cctotal, total_tcheck;
    #endif
    
    double ** U, ** u_current, ** u_previous, ** swap; //Global matrix, local current and previous matrices, pointer to swap between current and previous
    

    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD,&size);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);

    //----Read 2D-domain dimensions and process grid dimensions from stdin----//

    if (argc!=5) {
        fprintf(stderr,"Usage: mpirun .... ./exec X Y Px Py");
        exit(-1);
    }
    else {
        global[0]=atoi(argv[1]);
        global[1]=atoi(argv[2]);
        grid[0]=atoi(argv[3]);
        grid[1]=atoi(argv[4]);
    }

    //----Create 2D-cartesian communicator----//
	//----Usage of the cartesian communicator is optional----//

    MPI_Comm CART_COMM;         //CART_COMM: the new 2D-cartesian communicator
    int periods[2]={0,0};       //periods={0,0}: the 2D-grid is non-periodic
    int rank_grid[2];           //rank_grid: the position of each process on the new communicator
		
    MPI_Cart_create(MPI_COMM_WORLD,2,grid,periods,0,&CART_COMM);    //communicator creation
    MPI_Cart_coords(CART_COMM,rank,2,rank_grid);	                //rank mapping on the new communicator

    //----Compute local 2D-subdomain dimensions----//
    //----Test if the 2D-domain can be equally distributed to all processes----//
    //----If not, pad 2D-domain----//
    
    for (i=0;i<2;i++) {
        if (global[i]%grid[i]==0) {
            local[i]=global[i]/grid[i];
            global_padded[i]=global[i];
        }
        else {
            local[i]=(global[i]/grid[i])+1;
            global_padded[i]=local[i]*grid[i];
        }
    }

	//Initialization of omega
    omega=2.0/(1+sin(3.14/global[0]));

    //----Allocate global 2D-domain and initialize boundary values----//
    //----Rank 0 holds the global 2D-domain----//
    if (rank==0) {
        U=allocate2d(global_padded[0],global_padded[1]);   
        init2d(U,global[0],global[1]);
    }

    //----Allocate local 2D-subdomains u_current, u_previous----//
    //----Add a row/column on each size for ghost cells----//

    u_previous=allocate2d(local[0]+2,local[1]+2);
    u_current=allocate2d(local[0]+2,local[1]+2);   
       
    //----Distribute global 2D-domain from rank 0 to all processes----//
         
 	//----Appropriate datatypes are defined here----//
	/*****The usage of datatypes is optional*****/
    
    //----Datatype definition for the 2D-subdomain on the global matrix----//

    MPI_Datatype global_block;
    MPI_Type_vector(local[0],local[1],global_padded[1],MPI_DOUBLE,&dummy);
    MPI_Type_create_resized(dummy,0,sizeof(double),&global_block);
    MPI_Type_commit(&global_block);

    //----Datatype definition for the 2D-subdomain on the local matrix----//

    MPI_Datatype local_block;
    MPI_Type_vector(local[0],local[1],local[1]+2,MPI_DOUBLE,&dummy);
    MPI_Type_create_resized(dummy,0,sizeof(double),&local_block);
    MPI_Type_commit(&local_block);

    //----Rank 0 defines positions and counts of local blocks (2D-subdomains) on global matrix----//
    int * scatteroffset, * scattercounts;
    if (rank==0) {
        scatteroffset=(int*)malloc(size*sizeof(int));
        scattercounts=(int*)malloc(size*sizeof(int));
        for (i=0;i<grid[0];i++)
            for (j=0;j<grid[1];j++) {
                scattercounts[i*grid[1]+j]=1;
                scatteroffset[i*grid[1]+j]=(local[0]*local[1]*grid[1]*i+local[1]*j);
            }
    }


    //----Rank 0 scatters the global matrix----//

	//*************DONE*******************//
	/*Fill your code here*/
	if (rank != 0) { // This is here to suppress compiler warnings
		scattercounts = NULL;
		scatteroffset = NULL;
    }

	MPI_Scatterv(
	rank==0 ? &U[0][0] : NULL, scattercounts, scatteroffset, global_block, 
	&u_previous[1][1], 1, local_block, 
	0, CART_COMM);

	/*Make sure u_current and u_previous are
		both initialized*/
	for(i=0;i<local[0]+2;i++)
		for(j=0;j<local[1]+2;j++) {
			if(i==0 || j==0 || i==local[0]+1 || j==local[1]+1) u_previous[i][j]=0;
			u_current[i][j] = u_previous[i][j];
		}

     //************************************//


    if (rank==0)
        free2d(U);

 
     
	//----Define datatypes or allocate buffers for message passing----//

	//*************DONE*******************//
	/*Fill your code here*/
	MPI_Datatype row, column;
	MPI_Type_contiguous(local[1], MPI_DOUBLE, &row);
	MPI_Type_vector(local[0], 1, local[1]+2, MPI_DOUBLE, &column);
	MPI_Type_commit(&row);
	MPI_Type_commit(&column);

	//************************************//


    //----Find the 4 neighbors with which a process exchanges messages----//

	//*************DONE*******************//
    int north, south, east, west;
	/*Fill your code here*/
	MPI_Cart_shift(CART_COMM, 0, -1, &south, &north);
	MPI_Cart_shift(CART_COMM, 1, 1, &west, &east);
	//MPI_Cart_shift(CART_COMM, 1, -1, &rank, &west);
	//MPI_Cart_shift(CART_COMM, 1, 1, &rank, &east);

	/*Make sure you handle non-existing
		neighbors appropriately*/

	// plums:
	// MPI_Cart_shift should return MPI_PROC_NULL for non-existing neighbors

	//************************************//



    //---Define the iteration ranges per process-----//
	//*************DONE*******************//

    int i_min,i_max,j_min,j_max;
	/*Fill your code here*/
	if(rank_grid[0]==0) i_min=2;	// Top boundary
	else i_min=1;

	if(rank_grid[1]==0) j_min=2;	// Left boundary
	else j_min=1;

	if(rank_grid[0]==grid[0]-1) i_max = global[0] - (rank_grid[0]*local[0])-1; // Bot + Pad Boundary
	else i_max=local[0];

	if(rank_grid[1]==grid[1]-1) j_max = global[1] - (rank_grid[1]*local[1])-1; // Right + Pad Boundary
	else j_max=local[1];

	/*Three types of ranges:
		-internal processes
		-boundary processes
		-boundary processes and padded global array
	*/

	//************************************//




 	//----Computational core----//   
	gettimeofday(&tts, NULL);
    #ifdef TEST_CONV
    for (t=0;t<T && !global_converged;t++) {
    #endif
    #ifndef TEST_CONV
    #undef T
    #define T 256
    for (t=0;t<T;t++) {
    #endif


	 	//*************DONE*******************//
		/*Fill your code here*/

		/*Compute and Communicate*/

		/*Add appropriate timers for computation*/
	MPI_Sendrecv(
	&u_previous[1][1], 1, row, north, 0, // Send my top row north
	&u_previous[local[0]+1][1], 1, row, south, 0, // Receive bottom ghost row from south
	CART_COMM, MPI_STATUS_IGNORE);

	MPI_Sendrecv(
	&u_previous[1][1], 1, column, west, 1, // Send left column west
	&u_previous[1][local[1]+1], 1, column, east, 1, // Receive right ghost column from east
	CART_COMM, MPI_STATUS_IGNORE);

	MPI_Sendrecv(
	&u_previous[local[0]][1], 1, row, south, 2, // Send bottom row south
	&u_previous[0][1], 1, row, north, 2, // Receive top ghost row from north
	CART_COMM, MPI_STATUS_IGNORE);

	MPI_Sendrecv(
	&u_previous[1][local[1]], 1, column, east, 3, // Send right column east
	&u_previous[1][0], 1, column, west, 3, // Receive left ghost column from west
	CART_COMM, MPI_STATUS_IGNORE);

	gettimeofday(&tcs,NULL);
	for(i=i_min; i<=i_max; i++) {
		for(j=j_min;j<=j_max; j++) {
		u_current[i][j] = (u_previous[i-1][j] + u_previous[i][j-1] + u_previous[i+1][j] + u_previous[i][j+1])/4.0;	
		}
	}

	// Swap current to previous
	swap = u_previous;
	u_previous = u_current;
	u_current = swap;




		#ifdef TEST_CONV
	gettimeofday(&tccs,NULL);
        if (t%C==0) {
			//*************DONE**************//
			/*Test convergence*/
		converged = converge(u_previous, u_current, i_min, i_max, j_min, j_max);
		MPI_Allreduce(&converged, &global_converged, 1, MPI_INT, MPI_LAND, MPI_COMM_WORLD);
		}		
	gettimeofday(&tccf,NULL);
	cctotal += (tccf.tv_sec-tccs.tv_sec) + (tccf.tv_usec-tccs.tv_usec)*0.000001;
		#endif


		//************************************//
 
         
        gettimeofday(&tcf,NULL);
	tcomp += (tcf.tv_sec-tcs.tv_sec)+(tcf.tv_usec-tcs.tv_usec)*0.000001;

    }
    gettimeofday(&ttf,NULL);

    ttotal=(ttf.tv_sec-tts.tv_sec)+(ttf.tv_usec-tts.tv_usec)*0.000001;

    MPI_Reduce(&ttotal,&total_time,1,MPI_DOUBLE,MPI_MAX,0,MPI_COMM_WORLD);
    MPI_Reduce(&tcomp,&comp_time,1,MPI_DOUBLE,MPI_MAX,0,MPI_COMM_WORLD);
    #ifdef TEST_CONV
    MPI_Reduce(&cctotal, &total_tcheck,1,MPI_DOUBLE,MPI_MAX,0,MPI_COMM_WORLD);
    #endif

    //----Rank 0 gathers local matrices back to the global matrix----//
   
    if (rank==0) {
            U=allocate2d(global_padded[0],global_padded[1]);
    }


	//*************DONE*******************//
	/*Fill your code here*/
	if (rank != 0) { // This is here to suppress compiler warnings
		scattercounts = NULL;
		scatteroffset = NULL;
    }

	MPI_Gatherv(
	&u_previous[1][1], 1, local_block,
	rank==0 ? &U[0][0] : NULL, scattercounts, scatteroffset, global_block,
	0, CART_COMM);

     //************************************//


	
   

	//----Printing results----//

	//**************TODO: Change "Jacobi" to "GaussSeidelSOR" or "RedBlackSOR" for appropriate printing****************//
    if (rank==0) {
        printf("Jacobi X %d Y %d Px %d Py %d Iter %d ComputationTime %lf TotalTime %lf midpoint %lf\n",global[0],global[1],grid[0],grid[1],t,comp_time,total_time,U[global[0]/2][global[1]/2]);
	#ifdef TEST_CONV
	printf("Total Convergence Computation Time: %lf\n", total_tcheck);
	#endif
        #ifdef PRINT_RESULTS
        char * s=malloc(50*sizeof(char));
        sprintf(s,"resJacobiMPI_%dx%d_%dx%d",global[0],global[1],grid[0],grid[1]);
        fprint2d(s,U,global[0],global[1]);
        free(s);
        #endif

    }
    MPI_Finalize();
    return 0;
}
